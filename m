Return-Path: <kvm+bounces-2263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6665F7F41B7
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 10:32:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F8A0281897
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 09:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6336651024;
	Wed, 22 Nov 2023 09:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDQVKlj3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D323E480
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 09:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F381C433CA
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 09:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700645545;
	bh=9XGTgjbKxKcWOWT4IVqY0/FvOJLVF99Fo4JVCYhWn64=;
	h=From:To:Subject:Date:From;
	b=dDQVKlj3bbOwQLHBA9j2dYmWnV+BpRdR/It+IAYOJJU2A8P5PFW8Pv8e+gW+Gs3ui
	 SuefwHkGLEGlxs9ElTGJrBTKGMdu0x1lW82n86jtoatXvD5lCF1NXQaaSZ21w7adgM
	 rv3VA86J6w8sKiZNyBxX51t87ZShdKihWbzpOFzxOnMU5Ob4N3B0WCVog/MIgM7ZiH
	 9eWzu1JwJ0e/u7iyE75k2wDYEun+jl66EbbH+IWhUJi7/9aYz3xNdq7m8foYYJbyEj
	 ok8eErpk8jjIrNms3cVRBqLqIzIduhKvLhG3sIkmbKcSzX1ZCGcsmrUbaVtv7OSYi+
	 Nmui7YQdSJGPA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6C63EC53BD1; Wed, 22 Nov 2023 09:32:25 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218177] New: qemu got sigabrt when using vpp in guest and dpdk
 for qemu
Date: Wed, 22 Nov 2023 09:32:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zhang.lei.fly@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218177-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218177

            Bug ID: 218177
           Summary: qemu got sigabrt when using vpp in guest and dpdk for
                    qemu
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zhang.lei.fly@gmail.com
        Regression: No

I am testing vpp in qemu guest. and the guest is using dpdk interface provi=
ded
by dpdk.

when i set the interface up in vpp, the qemu is crashed



after doing some deep debug, this is happend in the `setup_routing_entry`
function


```
static int setup_routing_entry(struct kvm *kvm,
                               struct kvm_irq_routing_table *rt,
                               struct kvm_kernel_irq_routing_entry *e,
                               const struct kvm_irq_routing_entry *ue)
{
        struct kvm_kernel_irq_routing_entry *ei;
        int r;
        u32 gsi =3D array_index_nospec(ue->gsi, KVM_MAX_IRQ_ROUTES);

        /*
         * Do not allow GSI to be mapped to the same irqchip more than once.
         * Allow only one to one mapping between GSI and non-irqchip routin=
g.
         */
        hlist_for_each_entry(ei, &rt->map[gsi], link)
                if (ei->type !=3D KVM_IRQ_ROUTING_IRQCHIP ||
                    ue->type !=3D KVM_IRQ_ROUTING_IRQCHIP ||
                    ue->u.irqchip.irqchip =3D=3D ei->irqchip.irqchip)
                        return -EINVAL;

```

the code run into `return -EINVAL`=20

and the each field value is:

ei->type: 2,=20
KVM_IRQ_ROUTING_IRQCHIP: 1,
ue->type: 1,
ue->u.irqchip.irqchip: 2 ,
ei->irqchip.irqchip: -18870272

i am not familiar with kernel, but i guess there maybe some bug here?=20

Here is other informations

qemu-kvm version: qemu-kvm-7.2.0-14.el9
kernel:  4.18.0-477.27.1.el8.x86_64
ovs: 2.16.3
dpdk: 20.11.3

the qemu xml is attached

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

