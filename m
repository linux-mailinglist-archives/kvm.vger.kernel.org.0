Return-Path: <kvm+bounces-36178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56103A18549
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 19:35:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 408983AB7B2
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800ED1F5436;
	Tue, 21 Jan 2025 18:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="NQj/ANmX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13588BEC;
	Tue, 21 Jan 2025 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737484510; cv=none; b=fNArmZ34WByLPGVruR23AiiZ7/aXPHjeiOxDXL9tqGHbG4/SEPVjFRLSS4909i9EYE6P1iXTG8tCBO7zcJLmjvkHpgGKRZ5T7FYyIFDQg9FMBGUT5vNKwkvj/yCAMhaBr8xkWo8qPlUg1uWI0OeYs6eWlX00canD63a5VlXWVG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737484510; c=relaxed/simple;
	bh=zioiELri2bbKUZA5iJKjNU3x7gbn6LaRKQrwZLKDuSo=;
	h=Subject:MIME-Version:Content-Type:Date:Message-ID:CC:From:To:
	 References:In-Reply-To; b=IhC4L/eMAjn9poTiH68R8A+1q0UPWtz5Yp5mJcshVJZDraG7sTSFjfBxbNj+EEf7FiMQkI48ODGtg7M2XBVBh1OGdOJQx+YdFEtLw7ixQbgY5rJpAIreWi0vj5N0PXc6Okb5pDr+04njyw+fT1AhE+CutZBDBFNa/NOFdsr+W04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.es; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=NQj/ANmX; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.es
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1737484509; x=1769020509;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=C/k7aoKQmXURtKxIX6BzaTRc7fIKc7Gcjulas4yt2Tk=;
  b=NQj/ANmXTHLyGQTr/j/VXFQqPxzr6kKB3DrxqIAnC9DnnBV/tyInSl+b
   sNeoPQeEWYzkNQ4C23xa0Qy382faqhmfP62TTCUSAGT05u+DK1RgpkFU6
   K2NzwP0Mu/tOlvWTQwJpcUKpTjj0x006SfVoV7E7ZqMjJi2hDOr3kxaHG
   0=;
X-IronPort-AV: E=Sophos;i="6.13,222,1732579200"; 
   d="scan'208";a="264740713"
Subject: Re: [PATCH 5/5] Documentation: kvm: introduce "VM plane" concept
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 18:35:05 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.43.254:6305]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.31.172:2525] with esmtp (Farcaster)
 id ed8904b8-4ec4-494e-89a1-85c70c80ec24; Tue, 21 Jan 2025 18:35:04 +0000 (UTC)
X-Farcaster-Flow-ID: ed8904b8-4ec4-494e-89a1-85c70c80ec24
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Tue, 21 Jan 2025 18:35:04 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39; Tue, 21 Jan 2025
 18:34:59 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jan 2025 18:34:56 +0000
Message-ID: <D77YUMCRT8A8.1QZOJD3EQG58W@amazon.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <roy.hopkins@suse.com>, <michael.roth@amd.com>,
	<ashish.kalra@amd.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<anelkz@amazon.de>, <oliver.upton@linux.dev>, <isaku.yamahata@intel.com>,
	<maz@kernel.org>, <steven.price@arm.com>, <kai.huang@intel.com>,
	<rick.p.edgecombe@intel.com>, <James.Bottomley@hansenpartnership.com>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: aerc 0.19.0-9-g5a90e2f3553b
References: <20241023124507.280382-1-pbonzini@redhat.com>
 <20241023124507.280382-6-pbonzini@redhat.com> <Z4rQIGxwUNr5UQX0@google.com>
 <D77OZ0KEG5FP.2BZQFEKQUQZ0P@amazon.com> <Z4_XX--PvhC9PBNB@google.com>
In-Reply-To: <Z4_XX--PvhC9PBNB@google.com>
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Tue Jan 21, 2025 at 5:20 PM UTC, Sean Christopherson wrote:
> On Tue, Jan 21, 2025, Nicolas Saenz Julienne wrote:
>> On Fri Jan 17, 2025 at 9:48 PM UTC, Sean Christopherson wrote:
>> > On Wed, Oct 23, 2024, Paolo Bonzini wrote:
>> >> @@ -6398,6 +6415,46 @@ the capability to be present.
>> >>  `flags` must currently be zero.
>> >> +.. _KVM_CREATE_PLANE:
>> >> +
>> >> +4.144 KVM_CREATE_PLANE
>> >> +----------------------
>> >> +
>> >> +:Capability: KVM_CAP_PLANE
>> >> +:Architectures: none
>> >> +:Type: vm ioctl
>> >> +:Parameters: plane id
>> >> +:Returns: a VM fd that can be used to control the new plane.
>> >> +
>> >> +Creates a new *plane*, i.e. a separate privilege level for the
>> >> +virtual machine.  Each plane has its own memory attributes,
>> >> +which can be used to enable more restricted permissions than
>> >> +what is allowed with ``KVM_SET_USER_MEMORY_REGION``.
>> >> +
>> >> +Each plane has a numeric id that is used when communicating
>> >> +with KVM through the :ref:`kvm_run <kvm_run>` struct.  While
>> >> +KVM is currently agnostic to whether low ids are more or less
>> >> +privileged, it is expected that this will not always be the
>> >> +case in the future.  For example KVM in the future may use
>> >> +the plane id when planes are supported by hardware (as is the
>> >> +case for VMPLs in AMD), or if KVM supports accelerated plane
>> >> +switch operations (as might be the case for Hyper-V VTLs).
>> >> +
>> >> +4.145 KVM_CREATE_VCPU_PLANE
>> >> +---------------------------
>> >> +
>> >> +:Capability: KVM_CAP_PLANE
>> >> +:Architectures: none
>> >> +:Type: vm ioctl (non default plane)
>> >> +:Parameters: vcpu file descriptor for the default plane
>> >> +:Returns: a vCPU fd that can be used to control the new plane
>> >> +          for the vCPU.
>> >> +
>> >> +Adds a vCPU to a plane; the new vCPU's id comes from the vCPU
>> >> +file descriptor that is passed in the argument.  Note that
>> >> + because of how the API is defined, planes other than plane 0
>> >> +can only have a subset of the ids that are available in plane 0.
>> >
>> > Hmm, was there a reason why we decided to add KVM_CREATE_VCPU_PLANE, a=
s opposed
>> > to having KVM_CREATE_PLANE create vCPUs?  IIRC, we talked about being =
able to
>> > provide the new FD, but that would be easy enough to handle in KVM_CRE=
ATE_PLANE,
>> > e.g. with an array of fds.
>>
>> IIRC we mentioned that there is nothing in the VSM spec preventing
>> higher VTLs from enabling a subset of vCPUs. That said, even the TLFS
>> mentions that doing so is not such a great idea (15.4 VTL Enablement):
>>
>> "Enable the target VTL on one or more virtual processors. [...] It is
>>  recommended that all VPs have the same enabled VTLs. Having a VTL
>>  enabled on some VPs (but not all) can lead to unexpected behavior."
>>
>> One thing I've been meaning to research is moving device emulation into
>> guest execution context by using VTLs. In that context, it might make
>> sense to only enable VTLs on specific vCPUs. But I'm only speculating.
>
> Creating vCPUs for a VTL in KVM doesn't need to _enable_ that VTL, and AI=
UI
> shouldn't enable the VTL, because HvCallEnablePartitionVtl "only" enables=
 the VTL
> for the VM, HvCallEnableVpVtl is what fully enables the VTL for a given v=
CPU.

Yes.

> What I am proposing is to create the KVM vCPU object(s) at KVM_CREATE_PLA=
NE,
> purely to help avoid NULL pointer dereferences.  Actually, since KVM will=
 likely
> need uAPI to let userspace enable a VTL for a vCPU even if the vCPU objec=
t is
> auto-created, we could have KVM auto-create the objects transparently, i.=
e. still
> provide KVM_CREATE_VCPU_PLANE, but under the hood it would simply enable =
a flag
> and install the vCPU's file descriptor.

Sounds good. I like the idea of keeping KVM_CREATE_VCPU_PLANE around. It
also leaves the door open to creating the objects at that stage if it
ever necessary.

Nicolas

