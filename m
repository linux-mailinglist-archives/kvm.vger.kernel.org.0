Return-Path: <kvm+bounces-36100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5370BA17C43
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 11:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3F0F18814A7
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 10:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C4E1F0E5C;
	Tue, 21 Jan 2025 10:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="vKsWUSoE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4A61A8409;
	Tue, 21 Jan 2025 10:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737456649; cv=none; b=Z46UEzPY2nGSQdCzy/R8uVVzwuFZ5r6VD+9Edw8VlLCMsUjL+K8a2HJRM3102coJztyzyGJjyFEmBufmtEbqMcnAAB4K6pj77xBQgfYfd+dXToNEOOuGbgIyMy3bygROrI+K6xWagGOV3KINNd3R7/abWUd3A7xEhFUTe+QIK9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737456649; c=relaxed/simple;
	bh=78SvGEEpfplm+QtmRrw7sntzEgBlDVIuLcdixRRZlHo=;
	h=Subject:MIME-Version:Content-Type:Date:Message-ID:CC:From:To:
	 References:In-Reply-To; b=o4px5fobmQ5XFw7su6OwsrG9iZodbgwiKtamd35L3MJMPDsWm/r0TtIXEBBSfoJJ9JbhYeddokCVF4zMuJZNocS9xWgkMRCja4urMBOJb2xX/1pSotNN76qyFTuxNNn7o+eQnEiP3ed50XNvIMaC4xb9wVm6wKPid5ejbWwkpn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.es; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=vKsWUSoE; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.es
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1737456648; x=1768992648;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=ZUMl6My3UOEtLoT92yvNaaCHoq5p5jikRjbcB3m2yvg=;
  b=vKsWUSoE9/vWqkHs4zEsl/xevS/LAu/ADfuODiFzA1nLnT4GAi33bxMX
   +l+yVrpC1yGqmwEfOtwOnYbyXKme97ClGuMuZ4E06m+1tm01edTI2kvjc
   ddLrhMQRldifrvtDbWV4Jgf7KcvPoOQXbXwdy6C05UbpDgBizZV42adsj
   k=;
X-IronPort-AV: E=Sophos;i="6.13,221,1732579200"; 
   d="scan'208";a="163002992"
Subject: Re: [PATCH 5/5] Documentation: kvm: introduce "VM plane" concept
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 10:50:44 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.43.254:28894]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.13.19:2525] with esmtp (Farcaster)
 id 7d5df69f-310e-4fe8-92d5-d134aa75454d; Tue, 21 Jan 2025 10:50:44 +0000 (UTC)
X-Farcaster-Flow-ID: 7d5df69f-310e-4fe8-92d5-d134aa75454d
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Tue, 21 Jan 2025 10:50:37 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39; Tue, 21 Jan 2025
 10:50:32 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jan 2025 10:50:29 +0000
Message-ID: <D77OZ0KEG5FP.2BZQFEKQUQZ0P@amazon.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<roy.hopkins@suse.com>, <michael.roth@amd.com>, <ashish.kalra@amd.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <anelkz@amazon.de>,
	<oliver.upton@linux.dev>, <isaku.yamahata@intel.com>, <maz@kernel.org>,
	<steven.price@arm.com>, <kai.huang@intel.com>, <rick.p.edgecombe@intel.com>,
	<James.Bottomley@hansenpartnership.com>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
X-Mailer: aerc 0.19.0-9-g5a90e2f3553b
References: <20241023124507.280382-1-pbonzini@redhat.com>
 <20241023124507.280382-6-pbonzini@redhat.com> <Z4rQIGxwUNr5UQX0@google.com>
In-Reply-To: <Z4rQIGxwUNr5UQX0@google.com>
X-ClientProxiedBy: EX19D044UWB003.ant.amazon.com (10.13.139.168) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Hi Sean,

On Fri Jan 17, 2025 at 9:48 PM UTC, Sean Christopherson wrote:
> On Wed, Oct 23, 2024, Paolo Bonzini wrote:
>> @@ -6398,6 +6415,46 @@ the capability to be present.
>>  `flags` must currently be zero.
>>
>>
>> +.. _KVM_CREATE_PLANE:
>> +
>> +4.144 KVM_CREATE_PLANE
>> +----------------------
>> +
>> +:Capability: KVM_CAP_PLANE
>> +:Architectures: none
>> +:Type: vm ioctl
>> +:Parameters: plane id
>> +:Returns: a VM fd that can be used to control the new plane.
>> +
>> +Creates a new *plane*, i.e. a separate privilege level for the
>> +virtual machine.  Each plane has its own memory attributes,
>> +which can be used to enable more restricted permissions than
>> +what is allowed with ``KVM_SET_USER_MEMORY_REGION``.
>> +
>> +Each plane has a numeric id that is used when communicating
>> +with KVM through the :ref:`kvm_run <kvm_run>` struct.  While
>> +KVM is currently agnostic to whether low ids are more or less
>> +privileged, it is expected that this will not always be the
>> +case in the future.  For example KVM in the future may use
>> +the plane id when planes are supported by hardware (as is the
>> +case for VMPLs in AMD), or if KVM supports accelerated plane
>> +switch operations (as might be the case for Hyper-V VTLs).
>> +
>> +4.145 KVM_CREATE_VCPU_PLANE
>> +---------------------------
>> +
>> +:Capability: KVM_CAP_PLANE
>> +:Architectures: none
>> +:Type: vm ioctl (non default plane)
>> +:Parameters: vcpu file descriptor for the default plane
>> +:Returns: a vCPU fd that can be used to control the new plane
>> +          for the vCPU.
>> +
>> +Adds a vCPU to a plane; the new vCPU's id comes from the vCPU
>> +file descriptor that is passed in the argument.  Note that
>> + because of how the API is defined, planes other than plane 0
>> +can only have a subset of the ids that are available in plane 0.
>
> Hmm, was there a reason why we decided to add KVM_CREATE_VCPU_PLANE, as o=
pposed
> to having KVM_CREATE_PLANE create vCPUs?  IIRC, we talked about being abl=
e to
> provide the new FD, but that would be easy enough to handle in KVM_CREATE=
_PLANE,
> e.g. with an array of fds.

IIRC we mentioned that there is nothing in the VSM spec preventing
higher VTLs from enabling a subset of vCPUs. That said, even the TLFS
mentions that doing so is not such a great idea (15.4 VTL Enablement):

"Enable the target VTL on one or more virtual processors. [...] It is
 recommended that all VPs have the same enabled VTLs. Having a VTL
 enabled on some VPs (but not all) can lead to unexpected behavior."

One thing I've been meaning to research is moving device emulation into
guest execution context by using VTLs. In that context, it might make
sense to only enable VTLs on specific vCPUs. But I'm only speculating.

Otherwise, I cannot think of real world scenarios where this property is
needed.

> k.g. is the expectation that userspace will create all planes before crea=
ting
> any vCPUs?

The opposite really, VTLs can be initiated anytime during runtime.

> My concern with relying on userspace to create vCPUs is that it will mean=
 KVM
> will need to support, or at least not blow up on, VMs with multiple plane=
s, but
> only a subset of vCPUs at planes > 0.  Given the snafus with vcpus_array,=
 it's
> not at all hard to imagine scenarios where KVM tries to access a NULL vCP=
U in
> a different plane.

