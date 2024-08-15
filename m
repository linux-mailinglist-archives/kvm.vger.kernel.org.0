Return-Path: <kvm+bounces-24235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19ABC952A22
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 09:46:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CDC01C2012C
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 07:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DA819DF46;
	Thu, 15 Aug 2024 07:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IElS6oFi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D23C19D8B4
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 07:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723707919; cv=none; b=O1Jdpg71pvEWJ07Guj0OxlIOBvHkwjZMgTyRQaWnpueMXw7h99pt6+NCiQrdS3XnLREFnvwTbVB4HtcPOUxuooXdh+ERQlQnIbFCALgJ3gHzwsKG6wMlkX/D0drPuZgMz35cYobsSNgF6RS2tGInPYB13+ecupqXKpLcRuSffvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723707919; c=relaxed/simple;
	bh=NZYRlcWYQqhKpo6cdGndHE2sh/DkSLioekUmRpUShtE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=R6OgCytbcMEh4e9XjBp218VEEfbKfeHsW+uZfUmRk4nRwrpEsmH6MvSZYZiXlZ8K9vp6Iaj+GCMW2QEDWhoNXhW1YUq/wFCdMKpq4VBW35HhSdNeojhXrksoRDLVadSwBCWn270XxWaIP7SsULaD3BMgmS6ZyI1O2CBRoxx5nBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IElS6oFi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04E7EC32786
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 07:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723707919;
	bh=NZYRlcWYQqhKpo6cdGndHE2sh/DkSLioekUmRpUShtE=;
	h=From:To:Subject:Date:From;
	b=IElS6oFif+XT+MGuPZbx1Oi/d58pLpQhmUbqD0ZOyYaGcMN31N0QYd+zj8+VtWv6c
	 uVl8ssJqhKfDDUEPyhQI0oYCHUIgrjs0nzn7LE3cPH7xrwUhHuvgbXB7nDcxAOLHV/
	 UoMhQfccE+FZ3NQSKNdzlPGS4v5nmL/WlHnkPPnxFwzf/44EL6FV8r8ZVx1mFnkVPf
	 CGrBO0wsHQSxzYwpddITkbdq/hI3dON3GzQS5Ty4DQpDJ4hbjFAC0e3BXmMWJY6P14
	 OPrI2A0GtJnt90utRU3fpRrGySVcVj+KsZ1IpWvo509dcFQzrl45eZnaYVoJwjb7mk
	 gN3mO7IJVMZQA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E1161C433E5; Thu, 15 Aug 2024 07:45:18 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219161] New: VM with virtio-net doesn't receive large UDP
 packets (e.g 65507 bytes) from host
Date: Thu, 15 Aug 2024 07:45:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wquan@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219161-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219161

            Bug ID: 219161
           Summary: VM with virtio-net doesn't receive large UDP packets
                    (e.g 65507 bytes) from host
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: wquan@redhat.com
        Regression: No

Description=EF=BC=9A
Large UDP packets (e.g 65507 bytes) are not received in VM using virtio-net
when sent from host to VM, while smaller packets are received successfully.=
=20

The issue occurs with or without vhost enabled, and can be reproduce with
6.5.0-rc5+

Build Date & Hardware:
   6.11.0-rc2+ (d4560686726f7a357922f300fc81f5964be8df04 Merge tag 'for_lin=
us'
of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost)=20

Steps to Reproduce:

1. boot a vm from kvm

 -device '{"id": "pcie-root-port-3", "port": 3, "driver": "pcie-root-port",
"addr": "0x1.0x3", "bus": "pcie.0", "chassis": 4}' \
 -device '{"driver": "virtio-net-pci", "mac": "9a:59:9c:26:c7:52", "id":
"id1GUehY", "netdev": "idIlyxUy", "bus": "pcie-root-port-3", "addr": "0x0"}=
' \
 -netdev '{"id": "idIlyxUy", "type": "tap", "vhost": true}'  \

2. on vm, disable iptables and nftables. then run "netserver"
3. on host
 # netperf -H 192.168.58.21 -t UDP_STREAM -- -m  65507
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.5=
8.21
() port 0 AF_INET : interval : demo
Socket  Message  Elapsed      Messages
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

212992   65507   10.00      385575      0    20206.13
212992           10.00          86              4.51

# netperf -H 192.168.58.21 -t UDP_STREAM -- -m  2800
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.5=
8.21
() port 0 AF_INET : interval : demo
Socket  Message  Elapsed      Messages
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

212992    2800   10.00     5125735      0    11481.60
212992           10.00     3562544           7980.07

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

