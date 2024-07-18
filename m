Return-Path: <kvm+bounces-21814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB72F93479B
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 07:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C313282419
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 05:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E7A46426;
	Thu, 18 Jul 2024 05:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UEzxCeEd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1106542078
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 05:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721280516; cv=none; b=prjdvH6VyFphX+bNS0RuOKr2POojyZ76J5SYBJaQAH4xmp9GdbEmyfqwpeQZmxejHy6/24fDKfWOLZOSVzli9CThxAh9AHucaOrHgkjV+osPjM2zWqHkjOHL+f3zEB+OPVsK4axs9YLiOmIYH9IjPRN3IuFOaDOuldoj33PkbDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721280516; c=relaxed/simple;
	bh=/n30pXRSaPg6/RNVS5KqTJU65apInj9L15dc5ZlOJWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GvCN+c8gexONKRiKN4Nlx1IyfEmklPz3hF0cKHP9lvDeK5xvI7cV6+CYQ7Q7touXq4wPPVVqVj+Aqy2YhrFK5357S06I5j1InJfGgP2ykUxBUbL3JhLPRE+D2CTRhHdgZtNgFcIStuD8mX4HhiZxCF32ihNb80tE7iyL+xJ03Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UEzxCeEd; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721280514; x=1752816514;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/n30pXRSaPg6/RNVS5KqTJU65apInj9L15dc5ZlOJWI=;
  b=UEzxCeEdwk+zMoftk7ryKROOaslFnyjFKaHgyxafUxDdSaB0JIoOtTZS
   pFLm31ERGKqkpZFVE5xqOOV1o/Um45GZTSmeU3QFjAdwsj5FwaOAR+1PU
   nNOj9AT7Mwx0pvl2Kzb3E9259YXsvEgxHlKbyiI8zRMg9kHdmlIAlKTqI
   B+Dm96zFPfK1OL1M5Z/11RgPD8KMVUwGxhdae/Ta4MWvlkt3WJ6h6nbyb
   swjldpX8cFGIDfjXUWvTOTRpxaVk2WTbtaOkrWv/H8ZAJfqBuDfxnsBwt
   HgO3J99+rsxp7Bua4FVUh8ulUf/tCiYzKyT0TI6UnPr2P+Cbj4q6JszT7
   g==;
X-CSE-ConnectionGUID: nO6n9GuAQwqEMsUajcjIBQ==
X-CSE-MsgGUID: 2zuQRXPbST+Jqn4cG+7i2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11136"; a="18671312"
X-IronPort-AV: E=Sophos;i="6.09,216,1716274800"; 
   d="scan'208";a="18671312"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 22:28:33 -0700
X-CSE-ConnectionGUID: 1d43GwztQwePSZ+OmH1dMg==
X-CSE-MsgGUID: 3F6yikizQVyqX8j1PyIE4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,216,1716274800"; 
   d="scan'208";a="55777879"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.1]) ([10.124.225.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 22:28:29 -0700
Message-ID: <f18ab76c-abbe-4599-9631-603853bcfa0b@linux.intel.com>
Date: Thu, 18 Jul 2024 13:28:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 3/5] i386/kvm: Support event with select&umask format in KVM
 PMU filter
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti
 <mtosatti@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
 Eric Auger <eauger@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Mingwei Zhang <mizhang@google.com>, Jim Mattson <jmattson@google.com>
References: <20240710045117.3164577-1-zhao1.liu@intel.com>
 <20240710045117.3164577-4-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240710045117.3164577-4-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 7/10/2024 12:51 PM, Zhao Liu wrote:
> The select&umask is the common way for x86 to identify the PMU event,
> so support this way as the "x86-default" format in kvm-pmu-filter
> object.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  accel/kvm/kvm-pmu.c      | 62 ++++++++++++++++++++++++++++++++++++++++
>  include/sysemu/kvm-pmu.h | 13 +++++++++
>  qapi/kvm.json            | 46 +++++++++++++++++++++++++++--
>  target/i386/kvm/kvm.c    |  5 ++++
>  4 files changed, 123 insertions(+), 3 deletions(-)
>
> diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
> index 483d1bdf4807..51d3fba5a72a 100644
> --- a/accel/kvm/kvm-pmu.c
> +++ b/accel/kvm/kvm-pmu.c
> @@ -17,6 +17,8 @@
>  #include "qom/object_interfaces.h"
>  #include "sysemu/kvm-pmu.h"
>  
> +#define UINT12_MAX (4095)
> +
>  static void kvm_pmu_filter_get_event(Object *obj, Visitor *v, const char *name,
>                                       void *opaque, Error **errp)
>  {
> @@ -38,6 +40,12 @@ static void kvm_pmu_filter_get_event(Object *obj, Visitor *v, const char *name,
>              str_event->u.raw.code = g_strdup_printf("0x%lx",
>                                                      event->u.raw.code);
>              break;
> +        case KVM_PMU_EVENT_FMT_X86_DEFAULT:
> +            str_event->u.x86_default.select =
> +                g_strdup_printf("0x%x", event->u.x86_default.select);
> +            str_event->u.x86_default.umask =
> +                g_strdup_printf("0x%x", event->u.x86_default.umask);
> +            break;
>          default:
>              g_assert_not_reached();
>          }
> @@ -83,6 +91,60 @@ static void kvm_pmu_filter_set_event(Object *obj, Visitor *v, const char *name,
>                  goto fail;
>              }
>              break;
> +        case KVM_PMU_EVENT_FMT_X86_DEFAULT: {
> +            uint64_t select, umask;
> +
> +            ret = qemu_strtou64(str_event->u.x86_default.select, NULL,
> +                                0, &select);
> +            if (ret < 0) {
> +                error_setg(errp,
> +                           "Invalid %s PMU event (select: %s): %s. "
> +                           "The select must be a "
> +                           "12-bit unsigned number string.",
> +                           KVMPMUEventEncodeFmt_str(str_event->format),
> +                           str_event->u.x86_default.select,
> +                           strerror(-ret));
> +                g_free(event);
> +                goto fail;
> +            }
> +            if (select > UINT12_MAX) {
> +                error_setg(errp,
> +                           "Invalid %s PMU event (select: %s): "
> +                           "Numerical result out of range. "
> +                           "The select must be a "
> +                           "12-bit unsigned number string.",
> +                           KVMPMUEventEncodeFmt_str(str_event->format),
> +                           str_event->u.x86_default.select);
> +                g_free(event);
> +                goto fail;
> +            }
> +            event->u.x86_default.select = select;
> +
> +            ret = qemu_strtou64(str_event->u.x86_default.umask, NULL,
> +                                0, &umask);
> +            if (ret < 0) {
> +                error_setg(errp,
> +                           "Invalid %s PMU event (umask: %s): %s. "
> +                           "The umask must be a uint8 string.",
> +                           KVMPMUEventEncodeFmt_str(str_event->format),
> +                           str_event->u.x86_default.umask,
> +                           strerror(-ret));
> +                g_free(event);
> +                goto fail;
> +            }
> +            if (umask > UINT8_MAX) {

umask is extended to 16 bits from Perfmon v6+. Please notice we need to
upgrade this to 16 bits in the future. More details can be found here.
[PATCH V3 00/13] Support Lunar Lake and Arrow Lake core PMU - kan.liang
(kernel.org)
<https://lore.kernel.org/all/20240626143545.480761-1-kan.liang@linux.intel.com/>


> +                error_setg(errp,
> +                           "Invalid %s PMU event (umask: %s): "
> +                           "Numerical result out of range. "
> +                           "The umask must be a uint8 string.",
> +                           KVMPMUEventEncodeFmt_str(str_event->format),
> +                           str_event->u.x86_default.umask);
> +                g_free(event);
> +                goto fail;
> +            }
> +            event->u.x86_default.umask = umask;
> +            break;
> +        }
>          default:
>              g_assert_not_reached();
>          }
> diff --git a/include/sysemu/kvm-pmu.h b/include/sysemu/kvm-pmu.h
> index 4707759761f1..707f33d604fd 100644
> --- a/include/sysemu/kvm-pmu.h
> +++ b/include/sysemu/kvm-pmu.h
> @@ -26,4 +26,17 @@ struct KVMPMUFilter {
>      KVMPMUFilterEventList *events;
>  };
>  
> +/*
> + * Stolen from Linux kernel (RAW_EVENT at tools/testing/selftests/kvm/include/
> + * x86_64/pmu.h).
> + *
> + * Encode an eventsel+umask pair into event-select MSR format.  Note, this is
> + * technically AMD's format, as Intel's format only supports 8 bits for the
> + * event selector, i.e. doesn't use bits 24:16 for the selector.  But, OR-ing
> + * in '0' is a nop and won't clobber the CMASK.
> + */
> +#define X86_PMU_RAW_EVENT(eventsel, umask) (((eventsel & 0xf00UL) << 24) | \
> +                                            ((eventsel) & 0xff) | \
> +                                            ((umask) & 0xff) << 8)
> +
>  #endif /* KVM_PMU_H */
> diff --git a/qapi/kvm.json b/qapi/kvm.json
> index 0619da83c123..0d759884c229 100644
> --- a/qapi/kvm.json
> +++ b/qapi/kvm.json
> @@ -27,11 +27,13 @@
>  #
>  # @raw: the encoded event code that KVM can directly consume.
>  #
> +# @x86-default: standard x86 encoding format with select and umask.
> +#
>  # Since 9.1
>  ##
>  { 'enum': 'KVMPMUEventEncodeFmt',
>    'prefix': 'KVM_PMU_EVENT_FMT',
> -  'data': ['raw'] }
> +  'data': ['raw', 'x86-default'] }
>  
>  ##
>  # @KVMPMURawEvent:
> @@ -46,6 +48,25 @@
>  { 'struct': 'KVMPMURawEvent',
>    'data': { 'code': 'uint64' } }
>  
> +##
> +# @KVMPMUX86DefalutEvent:
> +#
> +# x86 PMU event encoding with select and umask.
> +# raw_event = ((select & 0xf00UL) << 24) | \
> +#              (select) & 0xff) | \
> +#              ((umask) & 0xff) << 8)
> +#
> +# @select: x86 PMU event select field, which is a 12-bit unsigned
> +#     number.
> +#
> +# @umask: x86 PMU event umask field.
> +#
> +# Since 9.1
> +##
> +{ 'struct': 'KVMPMUX86DefalutEvent',
> +  'data': { 'select': 'uint16',
> +            'umask': 'uint8' } }
> +
>  ##
>  # @KVMPMUFilterEvent:
>  #
> @@ -61,7 +82,8 @@
>    'base': { 'action': 'KVMPMUFilterAction',
>              'format': 'KVMPMUEventEncodeFmt' },
>    'discriminator': 'format',
> -  'data': { 'raw': 'KVMPMURawEvent' } }
> +  'data': { 'raw': 'KVMPMURawEvent',
> +            'x86-default': 'KVMPMUX86DefalutEvent' } }
>  
>  ##
>  # @KVMPMUFilterProperty:
> @@ -89,6 +111,23 @@
>  { 'struct': 'KVMPMURawEventVariant',
>    'data': { 'code': 'str' } }
>  
> +##
> +# @KVMPMUX86DefalutEventVariant:
> +#
> +# The variant of KVMPMUX86DefalutEvent with the string, rather than
> +# the numeric value.
> +#
> +# @select: x86 PMU event select field.  This field is a 12-bit
> +#     unsigned number string.
> +#
> +# @umask: x86 PMU event umask field. This field is a uint8 string.
> +#
> +# Since 9.1
> +##
> +{ 'struct': 'KVMPMUX86DefalutEventVariant',
> +  'data': { 'select': 'str',
> +            'umask': 'str' } }
> +
>  ##
>  # @KVMPMUFilterEventVariant:
>  #
> @@ -104,7 +143,8 @@
>    'base': { 'action': 'KVMPMUFilterAction',
>              'format': 'KVMPMUEventEncodeFmt' },
>    'discriminator': 'format',
> -  'data': { 'raw': 'KVMPMURawEventVariant' } }
> +  'data': { 'raw': 'KVMPMURawEventVariant',
> +            'x86-default': 'KVMPMUX86DefalutEventVariant' } }
>  
>  ##
>  # @KVMPMUFilterPropertyVariant:
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index e9bf79782316..391531c036a6 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5393,6 +5393,10 @@ kvm_config_pmu_event(KVMPMUFilter *filter,
>          case KVM_PMU_EVENT_FMT_RAW:
>              code = event->u.raw.code;
>              break;
> +        case KVM_PMU_EVENT_FMT_X86_DEFAULT:
> +            code = X86_PMU_RAW_EVENT(event->u.x86_default.select,
> +                                     event->u.x86_default.umask);
> +            break;
>          default:
>              g_assert_not_reached();
>          }
> @@ -6073,6 +6077,7 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
>  
>          switch (event->format) {
>          case KVM_PMU_EVENT_FMT_RAW:
> +        case KVM_PMU_EVENT_FMT_X86_DEFAULT:
>              break;
>          default:
>              error_setg(errp,

