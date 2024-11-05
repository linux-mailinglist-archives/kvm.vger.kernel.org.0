Return-Path: <kvm+bounces-30731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D48499BCC35
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:54:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6037A1F22F95
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F551D514E;
	Tue,  5 Nov 2024 11:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Quk51M8S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C0A1D47C6
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730807650; cv=none; b=P99MZfWrK1ekexyp2b43lvtQM4niLMWFHoMz5RtQwIs16xlPdqHWIuOM6OQtuKWElsPP+KT42Jd94B1j5MwUDqbbNeJcvj4HLSl5iZlsnSAp9YuelZqi+SdcdyjW/DpUidycgmMkesS+l1gwC6Xp/r//mdAYleXI/AI82ybj0PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730807650; c=relaxed/simple;
	bh=Oo+Ri+43hRdnQ/AWG2efhN9dxitEu8CNo4oXSZgdSbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPwAY1jhsR2JE++scm13LADxMo4rNC/k8t/EQPq1Ai+7f7O8aPezKr+3e/jb7bjYyE9MWZgJ9Ox/GHjUiXapFJce3LsOKc8ogS1ThnU9h8xviC7cZrYIzAuOnuOZE1Z7f9A0jvzYr0l8JUohTde6DfNCttNrfs4WymJxRSDDkYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Quk51M8S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730807647;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b5fDfx53ZSBgYR8OHgSEUnZXPbbkgehmSaTpCCC/NvY=;
	b=Quk51M8SDp437YVCrG3owv0mJB6nFpd9kZIWeWWsnsV3D752DPs8ARvr+3zKTH3TRTcdQB
	hoJvOYZsZmuODKcxGeTE7R5uGlk2CRApAyUH9TG3kJX0hA/Df96y7JzkoX3x8/Z3D1OBWN
	JQ28RdQMLzl/7KQ4FGpx5pm4JYBFD4I=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-w2gr8U1KPmG-WWxWF-gCrg-1; Tue,
 05 Nov 2024 06:54:04 -0500
X-MC-Unique: w2gr8U1KPmG-WWxWF-gCrg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 135C61955F40;
	Tue,  5 Nov 2024 11:54:02 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16E21195607C;
	Tue,  5 Nov 2024 11:53:54 +0000 (UTC)
Date: Tue, 5 Nov 2024 11:53:50 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 09/60] i386/tdx: Initialize TDX before creating TD
 vcpus
Message-ID: <ZyoHTuWRrtbyR6I0@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-10-xiaoyao.li@intel.com>
 <Zyn0oBKvOC9rvcqk@redhat.com>
 <f0283ac7-31bb-4d59-b45d-046f3e582d55@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0283ac7-31bb-4d59-b45d-046f3e582d55@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Nov 05, 2024 at 07:51:53PM +0800, Xiaoyao Li wrote:
> On 11/5/2024 6:34 PM, Daniel P. Berrangé wrote:
> > On Tue, Nov 05, 2024 at 01:23:17AM -0500, Xiaoyao Li wrote:
> > > Invoke KVM_TDX_INIT in kvm_arch_pre_create_vcpu() that KVM_TDX_INIT
> > > configures global TD configurations, e.g. the canonical CPUID config,
> > > and must be executed prior to creating vCPUs.
> > > 
> > > Use kvm_x86_arch_cpuid() to setup the CPUID settings for TDX VM.
> > > 
> > > Note, this doesn't address the fact that QEMU may change the CPUID
> > > configuration when creating vCPUs, i.e. punts on refactoring QEMU to
> > > provide a stable CPUID config prior to kvm_arch_init().
> > > 
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> > > Acked-by: Markus Armbruster <armbru@redhat.com>
> > > ---
> > > Changes in v6:
> > > - setup xfam explicitly to fit with new uapi;
> > > - use tdx_caps->cpuid to filter the input of cpuids because now KVM only
> > >    allows the leafs that reported via KVM_TDX_GET_CAPABILITIES;
> > > 
> > > Changes in v4:
> > > - mark init_vm with g_autofree() and use QEMU_LOCK_GUARD() to eliminate
> > >    the goto labels; (Daniel)
> > > Changes in v3:
> > > - Pass @errp in tdx_pre_create_vcpu() and pass error info to it. (Daniel)
> > > ---
> > >   accel/kvm/kvm-all.c         |  8 ++++
> > >   target/i386/kvm/kvm.c       | 15 +++++--
> > >   target/i386/kvm/kvm_i386.h  |  3 ++
> > >   target/i386/kvm/meson.build |  2 +-
> > >   target/i386/kvm/tdx-stub.c  |  8 ++++
> > >   target/i386/kvm/tdx.c       | 87 +++++++++++++++++++++++++++++++++++++
> > >   target/i386/kvm/tdx.h       |  6 +++
> > >   7 files changed, 125 insertions(+), 4 deletions(-)
> > >   create mode 100644 target/i386/kvm/tdx-stub.c

> > > +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
> > > +{
> > > +    X86CPU *x86cpu = X86_CPU(cpu);
> > > +    CPUX86State *env = &x86cpu->env;
> > > +    g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
> > > +    int r = 0;
> > > +
> > > +    QEMU_LOCK_GUARD(&tdx_guest->lock);
> > > +    if (tdx_guest->initialized) {
> > > +        return r;
> > > +    }
> > > +
> > > +    init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
> > > +                        sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
> > > +
> > > +    r = setup_td_xfam(x86cpu, errp);
> > > +    if (r) {
> > > +        return r;
> > > +    }
> > > +
> > > +    init_vm->cpuid.nent = kvm_x86_build_cpuid(env, init_vm->cpuid.entries, 0);
> > > +    tdx_filter_cpuid(&init_vm->cpuid);
> > > +
> > > +    init_vm->attributes = tdx_guest->attributes;
> > > +    init_vm->xfam = tdx_guest->xfam;
> > > +
> > > +    do {
> > > +        r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
> > > +    } while (r == -EAGAIN);
> > 
> > Other calls to tdx_vm_ioctl don't loop on EAGAIN. Is the need to
> > do this retry specific to only KVM_TDX_INIT_VM, or should we push
> > the EAGAIN retry logic inside tdx_vm_ioctl_helper so all callers
> > benefit ?
> 
> So far, only KVM_TDX_INIT_VM can get -EAGAIN due to KVM side TDH_MNG_CREATE
> gets TDX_RND_NO_ENTROPY because Random number generation (e.g., RDRAND or
> RDSEED) failed and in this case it should retry.

Ok, no problem.

> I think adding a commment to explain why it can get -EAGAIN and needs to
> retry should suffice?

Sure, a comment is useful.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


