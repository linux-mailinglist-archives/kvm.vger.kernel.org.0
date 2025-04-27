Return-Path: <kvm+bounces-44481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B730A9DFA4
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 08:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69166840AE8
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 06:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4899D241679;
	Sun, 27 Apr 2025 06:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PDgMCYRm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92729240611
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 06:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745735319; cv=none; b=eR9LivgPbewaqXu5phJev5uV3V7wH7yMOIM84dyE6HpafzOqu4RKNsJwlyRppcoACJLEAl6cqnNO2ExBXjNBHyrG9IoEbVzF9/MusvS3+YUKxfDaYglHX7XELguZ15lIWuVqj25bUa96OU+YfW+mWNpB8s/95JCcPGdNwU2sW9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745735319; c=relaxed/simple;
	bh=mnGbRICatNcyoPrI5GrAe65yEryXZhpnLlqHMQGHYqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXJDgnYapMPlfIENlg5isxmNwhrGlHSij0yIFSTTOmxAXdzAoR48ik9uzA2u8Q2svFYuOPkusZttdPC2ZWtVBh6oMbK0euK+mAO/taPOBMzhrW6AMiXVHsJbuMGorrBF+2biE4cz4XMCAK1rlmbYWMzBSnCyDCRo7GPSBfkKaaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PDgMCYRm; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745735317; x=1777271317;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mnGbRICatNcyoPrI5GrAe65yEryXZhpnLlqHMQGHYqQ=;
  b=PDgMCYRmKryqtmZNasYCwPZ0HGkBZH7mWCK0JPtbVlx+0O2rvj5hPKKL
   rmO18/DGv/TUT3ssla5LJmWMzOnBUPDwTpMH+FD6KNn19LxsG2tM8foTA
   lUNAiUZ2vKJJByDnb+c6FQ6piHPCfdd17ylLY5nqiucRgh7BiXDJYqeZv
   6G54J3j+V4MsWsq6uPOOYvRKk/qSUU8IV233Py7qgSZz2hqw5s6EbSo8j
   2bEAJfaty+42k0bWAptkKBz/K/gJZzPze3twkslaROkDuf8wOG9SSRMaW
   lzVwKlvH5HCMtJSzls3Osupwu/N1BMrniL2efjlzDorekhxsn1xfT9Exz
   Q==;
X-CSE-ConnectionGUID: OzoPTJ3+QAeybUltVpFg/w==
X-CSE-MsgGUID: KKlys74ESD2YHdS6f9vznA==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="49995861"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="49995861"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 23:28:37 -0700
X-CSE-ConnectionGUID: iO0zR2YdQPuksNBrc7RPBg==
X-CSE-MsgGUID: H4em+WpuSHWky0kg4kKVEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="133216649"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 26 Apr 2025 23:28:32 -0700
Date: Sun, 27 Apr 2025 14:49:29 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
Message-ID: <aA3TeaYG9mNMdEiW@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-4-zhao1.liu@intel.com>
 <87frhwfuv1.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87frhwfuv1.fsf@pond.sub.org>

Hi Markus,

> > +        case KVM_PMU_EVENT_FORMAT_X86_SELECT_UMASK: {
> > +            if (event->u.x86_select_umask.select > UINT12_MAX) {
> > +                error_setg(errp,
> > +                           "Parameter 'select' out of range (%d).",
> > +                           UINT12_MAX);
> > +                goto fail;
> > +            }
> > +
> > +            /* No need to check the range of umask since it's uint8_t. */
> > +            break;
> > +        }
> 
> As we'll see below, the new x86-specific format is defined in the QAPI
> schema regardless of target.
> 
> It is accepted here also regardless of target.  Doesn't matter much
> right now, as the object is effectively useless for targets other than
> x86, but I understand that will change.
> 
> Should we reject it unless the target is x86?

I previously supposed that different architectures should implement
their own kvm_arch_check_pmu_filter(), which is the `check` hook of
object_class_property_add_link():

    object_class_property_add_link(oc, "pmu-filter",
                                   TYPE_KVM_PMU_FILTER,
                                   offsetof(KVMState, pmu_filter),
                                   kvm_arch_check_pmu_filter,
                                   OBJ_PROP_LINK_STRONG);

For x86, I implemented kvm_arch_check_pmu_filter() in target/i386/kvm/
kvm.c and checked the supported formats (I also supposed arch-specific
PMU filter could reject the unsupported format in
kvm_arch_check_pmu_filter().)

But I think your idea is better, i.e., rejecting unsupported format
early in pmu-filter parsing.

Well, IIUC, there is no way to specify in QAPI that certain enumerations
are generic and certain enumerations are arch-specific, so rejecting
unsupported format can only happen in parsing code. For example, wrap
the above code in "#if defined(TARGET_I386)":

    for (node = head; node; node = node->next) {
        KvmPmuFilterEvent *event = node->value;

        switch (event->format) {
        case KVM_PMU_EVENT_FORMAT_RAW:
            break;
#if defined(TARGET_I386)
        case KVM_PMU_EVENT_FORMAT_X86_SELECT_UMASK: {
            ...
            break;
        }
        case KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY: {
            ...
	    break;
        }
#endif
        default:
	    error_setg(errp,
                       "Unsupported format.");
            goto fail;
        }

        ...
    }

EMM, do you like this idea?

> If not, I feel the behavior should be noted in the commit message.

With the above change, I think it's possible to reject x86-specific
format on non-x86 arch. And I can also note this behavior in commit
message.

> >          default:
> >              g_assert_not_reached();
> >          }
> > @@ -67,6 +82,9 @@ static void kvm_pmu_filter_set_event(Object *obj, Visitor *v, const char *name,
> >      filter->events = head;
> >      qapi_free_KvmPmuFilterEventList(old_head);
> >      return;
> > +
> > +fail:
> > +    qapi_free_KvmPmuFilterEventList(head);
> >  }
> >  
> >  static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)

...

> >  ##
> >  # @KvmPmuFilterEvent:
> >  #
> > @@ -66,7 +82,8 @@
> >  { 'union': 'KvmPmuFilterEvent',
> >    'base': { 'format': 'KvmPmuEventFormat' },
> >    'discriminator': 'format',
> > -  'data': { 'raw': 'KvmPmuRawEvent' } }
> > +  'data': { 'raw': 'KvmPmuRawEvent',
> > +            'x86-select-umask': 'KvmPmuX86SelectUmaskEvent' } }
> >  
> >  ##
> >  # @KvmPmuFilterProperties:
> 
> Documentation could perhaps be more explicit about this making sense
> only for x86.

What about the following doc?

##
# @KvmPmuFilterProperties:
#
# Properties of KVM PMU Filter (only for x86).

> > diff --git a/qemu-options.hx b/qemu-options.hx
> > index 51a7c61ce0b0..5dcce067d8dd 100644
> > --- a/qemu-options.hx
> > +++ b/qemu-options.hx
> > @@ -6180,6 +6180,9 @@ SRST
> >               ((select) & 0xff) | \
> >               ((umask) & 0xff) << 8)
> >  
> > +        ``{"format":"x86-select-umask","select":event_select,"umask":event_umask}``
> > +            Specify the single x86 PMU event with select and umask fields.
> > +
> >          An example KVM PMU filter object would look like:
> >  
> >          .. parsed-literal::
> > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > index fa3a696654cb..0d36ccf250ed 100644
> > --- a/target/i386/kvm/kvm.c
> > +++ b/target/i386/kvm/kvm.c
> > @@ -5974,6 +5974,10 @@ static bool kvm_config_pmu_event(KVMPMUFilter *filter,
> >          case KVM_PMU_EVENT_FORMAT_RAW:
> >              code = event->u.raw.code;
> >              break;
> > +        case KVM_PMU_EVENT_FORMAT_X86_SELECT_UMASK:
> > +            code = X86_PMU_RAW_EVENT(event->u.x86_select_umask.select,
> > +                                     event->u.x86_select_umask.umask);
> > +            break;
> >          default:
> >              g_assert_not_reached();
> >          }
> > @@ -6644,6 +6648,7 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
> >  
> >          switch (event->format) {
> >          case KVM_PMU_EVENT_FORMAT_RAW:
> > +        case KVM_PMU_EVENT_FORMAT_X86_SELECT_UMASK:

Here's the current format check I mentioned above. But I agree your idea
and will check in the parsing of pmu-filter object.

> >              break;
> >          default:
> >              error_setg(errp,
> 

