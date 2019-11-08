Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAFFF59D3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 22:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbfKHV0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 16:26:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726819AbfKHV0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 16:26:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573248389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kOlt9+gXfWdePLvgUtAlW7sjmc7CI8AXBtdIXNN9dd4=;
        b=FfVeZ5JOvx9jfXQMcp7ZRmKFpfX5sBSci4OLmopLjPRlJFNWSeieDZCPFY0aO/F2rajdTT
        haSoFntRp7NnzMs85FYCFmAr/mRbwydR6U+n4/UBwtYACxC/wXPqin2B3reFcH4KC3hMb1
        agSfGsl3Dr+BL0SlfL3ntlQQf4njNdc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-fEBVoNgAPgaqpLBVIXrIsw-1; Fri, 08 Nov 2019 16:26:27 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 659531800D7B;
        Fri,  8 Nov 2019 21:26:26 +0000 (UTC)
Received: from mail (ovpn-125-151.rdu2.redhat.com [10.10.125.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EC9C5D6AE;
        Fri,  8 Nov 2019 21:26:26 +0000 (UTC)
Date:   Fri, 8 Nov 2019 16:26:25 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jessica Yu <jeyu@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
Message-ID: <20191108212625.GB532@redhat.com>
References: <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com>
 <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
 <20191105135414.GA30717@redhat.com>
 <330acce5-a527-543b-84c0-f3d8d277a0e2@redhat.com>
 <20191105145651.GD30717@redhat.com>
 <ab18744b-afc7-75d4-b5f3-e77e9aae41a6@redhat.com>
 <20191108135631.GA22507@linux-8ccs>
 <b77283e5-a4bc-1849-fbfa-27741ab2dbd5@redhat.com>
 <20191108200103.GA532@redhat.com>
 <9a3d2936-bd26-430f-a962-9b0f6fe0c2a0@redhat.com>
MIME-Version: 1.0
In-Reply-To: <9a3d2936-bd26-430f-a962-9b0f6fe0c2a0@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: fEBVoNgAPgaqpLBVIXrIsw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 08, 2019 at 10:02:52PM +0100, Paolo Bonzini wrote:
> kvm_intel.ko or kvm_amd.ko, I'm not sure why that would be worse for TLB
> or RAM usage.  The hard part is recording the location of the call sites

Let's ignore the different code complexity of supporting self
modifying code: kvm.ko and kvm-*.ko will be located in different
pages, hence it'll waste 1 iTLB for every vmexit and 2k of RAM in
average. The L1 icache also will be wasted. It'll simply run slower.

Now about the code complexity, it is even higher than pvops:

   KVM=09=09=09=09pvops
   =3D=3D=3D=3D=3D=3D=3D=3D=3D                    =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
1) Changes daily=09=09Never change

2) Patched at runtime=09=09Patched only at boot time early on
   during module load
   and multiple times
   at every load of kvm-*.ko

3) The patching points to=09All patch destinations are linked into
   code in kernel modules       the kernel

Why exactly should we go through such a complication when it runs
slower in the end and it's much more complex to implement and maintain
and in fact even more complex than pvops already is?

Runtime patching the indirect call like pvops do is strictly required
when you are forced to resolve the linking at runtime. The alternative
would be to ship two different Linux kernels for PV and bare
metal. Maintaining a whole new kernel rpm and having to install a
different rpm depending on the hypervisor/bare metal is troublesome so
pvops is worth it.

With kvm-amd and kvm-intel we can avoid the whole runtime patching of
the call sites as already proven by KVM monolithic patchset, and it'll
run faster in the CPU and it'll save RAM, so I'm not exactly sure how
anybody could prefer runtime patching here when the only benefit is a
few mbytes of disk space saved on disk.

Furthermore by linking the thing statically we'll also enable LTO and
other gcc features which would never be possible with those indirect
calls.

Thanks,
Andrea

