Return-Path: <kvm+bounces-25117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11669960093
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 06:55:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E225B2179E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 04:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D9C71B3A;
	Tue, 27 Aug 2024 04:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lbiCpdw4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CFC45028;
	Tue, 27 Aug 2024 04:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724734509; cv=none; b=Fu+LF7bbfbNtBSpwgvdFk4FcbROmqZwB3pKOELtsXxD/FblXZq4eNUAEzWODvOnUdNmqq7hG2xRcC1qGun+450cWnDgMTyIkwM+o6HfUXf5cpUlE043QgXK+OJodwd7mYF3rH7m3Vmz5uEOZjjFEVbG7fgzB8fzFtgHBNvOKJrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724734509; c=relaxed/simple;
	bh=PdA0EpTBc8PSnwnMVFJg2PvKQseIM/bCCQkx0W8vh2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sjMgwf8J9lk6KzGZuCTkZ0hOdB9Wok1EoBGwupPUP0AqUm6BwyjoiW/fYiC16bXpDS+ED4TQrMFsOEy9J7EIcgO9V8KwcM7NzQZB+S6QfgE5yGpI5bxWnb0MLr2UYZPI8YlUM36AMxL0QHPPKAnCs+V2sJo0uZvFHR3E8GIuFu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lbiCpdw4; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724734507; x=1756270507;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PdA0EpTBc8PSnwnMVFJg2PvKQseIM/bCCQkx0W8vh2o=;
  b=lbiCpdw4YNVBxJqtNNgOtMATvY6UXUarPBv67/P9m7RgUuZImowgIujU
   8Xjc+pHhBYFI9B7Y4xYxEZiDfce+O4KAgGYEsyiRiYvM3o9Atk3REfoks
   ecTmDuNU9lYVH5g1fP51n54THxX6QsP1Y6en+A5z4flcuQrEj89kvCe5J
   kk/dJLhSpDK4rlodZxv2XTJSmECxBONypBJelU/4dk5azYtdtE054hVZm
   3fkqAut5V88M+0jFC7O9xql/I3Soepwf3bRSlAk7fNFcS4CQ2V/Y6jVIL
   gHhK8ZW7haqL+6a4BragZwRXrWm8M0uFdcDEiLer9t0Js8enBQL2QXDI/
   A==;
X-CSE-ConnectionGUID: c9l6BwfBQC+yyW0wlj4mFg==
X-CSE-MsgGUID: iXNsJ658TvWYQrHM+V8AAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="23073120"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="23073120"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 21:55:06 -0700
X-CSE-ConnectionGUID: cqa0QI58RDSrmJUsNwlFIg==
X-CSE-MsgGUID: lb8NBX+9SAeG4kCWpIu35A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="100238910"
Received: from unknown (HELO [10.0.2.15]) ([10.245.89.141])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 21:55:00 -0700
Message-ID: <7ae1fcac-cbea-478c-b8c9-d2c2a5dd6f11@intel.com>
Date: Tue, 27 Aug 2024 07:54:54 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave"
 <dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
 "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
 <peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Gao, Chao" <chao.gao@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>
References: <cover.1721186590.git.kai.huang@intel.com>
 <7af2b06ec26e2964d8d5da21e2e9fa412e4ed6f8.1721186590.git.kai.huang@intel.com>
 <66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch>
 <7b65b317-397d-4a72-beac-6b0140b1d8dd@intel.com>
 <66b178d4cfae4_4fc72944b@dwillia2-xfh.jf.intel.com.notmuch>
 <96c248b790907b14efcb0885c78e4000ba5b9694.camel@intel.com>
 <a107b067-861d-43f4-86b5-29271cb93dad@intel.com>
 <49dabff079d0b55bd169353d9ef159495ff2893e.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <49dabff079d0b55bd169353d9ef159495ff2893e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/08/24 01:40, Huang, Kai wrote:
> On Mon, 2024-08-26 at 18:38 +0300, Adrian Hunter wrote:
>> On 7/08/24 15:09, Huang, Kai wrote:
>>> On Mon, 2024-08-05 at 18:13 -0700, Dan Williams wrote:
>>>> Huang, Kai wrote:
>>>> [..]
>>>>>> The unrolled loop is the same amount of work as maintaining @fields.
>>>>>
>>>>> Hi Dan,
>>>>>
>>>>> Thanks for the feedback.
>>>>>
>>>>> AFAICT Dave didn't like this way:
>>>>>
>>>>> https://lore.kernel.org/lkml/cover.1699527082.git.kai.huang@intel.com/T/#me6f615d7845215c278753b57a0bce1162960209d
>>>>
>>>> I agree with Dave that the original was unreadable. However, I also
>>>> think he glossed over the loss of type-safety and the silliness of
>>>> defining an array to precisely map fields only to turn around and do a
>>>> runtime check that the statically defined array was filled out
>>>> correctly. So I think lets solve the readability problem *and* make the
>>>> array definition identical in appearance to unrolled type-safe
>>>> execution, something like (UNTESTED!):
>>>>
>>>>
>>> [...]
>>>
>>>> +/*
>>>> + * Assumes locally defined @ret and @ts to convey the error code and the
>>>> + * 'struct tdx_tdmr_sysinfo' instance to fill out
>>>> + */
>>>> +#define TD_SYSINFO_MAP(_field_id, _offset)                              \
>>>> + ({                                                              \
>>>> +         if (ret == 0)                                           \
>>>> +                 ret = read_sys_metadata_field16(                \
>>>> +                         MD_FIELD_ID_##_field_id, &ts->_offset); \
>>>> + })
>>>> +
>>>
>>> We need to support u16/u32/u64 metadata field sizes, but not just u16.
>>>
>>> E.g.:
>>>
>>> struct tdx_sysinfo_module_info {
>>>         u32 sys_attributes;
>>>         u64 tdx_features0;
>>> };
>>>
>>> has both u32 and u64 in one structure.
>>>
>>> To achieve type-safety for all field sizes, I think we need one helper
>>> for each field size.  E.g.,
>>>
>>> #define READ_SYSMD_FIELD_FUNC(_size)                            \
>>> static inline int                                               \
>>> read_sys_metadata_field##_size(u64 field_id, u##_size *data)    \
>>> {                                                               \
>>>         u64 tmp;                                                \
>>>         int ret;                                                \
>>>                                                                 \
>>>         ret = read_sys_metadata_field(field_id, &tmp);          \
>>>         if (ret)                                                \
>>>                 return ret;                                     \
>>>                                                                 \
>>>         *data = tmp;                                            \
>>>         return 0;                                               \
>>> }
>>>
>>> /* For now only u16/u32/u64 are needed */
>>> READ_SYSMD_FIELD_FUNC(16)
>>> READ_SYSMD_FIELD_FUNC(32)
>>> READ_SYSMD_FIELD_FUNC(64)
>>>
>>> Is this what you were thinking?
>>>
>>> (Btw, I recall that I tried this before for internal review, but AFAICT
>>> Dave didn't like this.)
>>>
>>> For the build time check as you replied to the next patch, I agree it's
>>> better than the runtime warning check as done in the current code.
>>>
>>> If we still use the type-less 'void *stbuf' function to read metadata
>>> fields for all sizes, then I think we can do below:
>>>
>>> /*
>>>  * Read one global metadata field and store the data to a location of a
>>>  * given buffer specified by the offset and size (in bytes).
>>>  */
>>> static int stbuf_read_sysmd_field(u64 field_id, void *stbuf, int offset,
>>>                                   int size)
>>> {
>>>         void *member = stbuf + offset;
>>>         u64 tmp;
>>>         int ret;
>>>
>>>         ret = read_sys_metadata_field(field_id, &tmp);
>>>         if (ret)
>>>                 return ret;
>>>
>>>         memcpy(member, &tmp, size);
>>>
>>>         return 0;
>>> }
>>>
>>> /* Wrapper to read one metadata field to u8/u16/u32/u64 */
>>> #define stbuf_read_sysmd_single(_field_id, _pdata)      \
>>>         stbuf_read_sysmd_field(_field_id, _pdata, 0,        \
>>>             sizeof(typeof(*(_pdata))))
>>>
>>> #define CHECK_MD_FIELD_SIZE(_field_id, _st, _member)    \
>>>         BUILD_BUG_ON(MD_FIELD_ELE_SIZE(MD_FIELD_ID_##_field_id) != \
>>>                         sizeof(_st->_member))
>>>
>>> #define TD_SYSINFO_MAP_TEST(_field_id, _st, _member)                    \
>>>         ({                                                              \
>>>                 if (ret) {                                              \
>>>                         CHECK_MD_FIELD_SIZE(_field_id, _st, _member);   \
>>>                         ret = stbuf_read_sysmd_single(                  \
>>>                                         MD_FIELD_ID_##_field_id,        \
>>>                                         &_st->_member);                 \
>>>                 }                                                       \
>>>          })
>>>
>>> static int get_tdx_module_info(struct tdx_sysinfo_module_info *modinfo)
>>> {
>>>         int ret = 0;
>>>
>>> #define TD_SYSINFO_MAP_MOD_INFO(_field_id, _member)     \
>>>         TD_SYSINFO_MAP_TEST(_field_id, modinfo, _member)
>>>
>>>         TD_SYSINFO_MAP_MOD_INFO(SYS_ATTRIBUTES, sys_attributes);
>>>         TD_SYSINFO_MAP_MOD_INFO(TDX_FEATURES0,  tdx_features0);
>>>
>>>         return ret;
>>> }
>>>
>>> With the build time check above, I think it's OK to lose the type-safe
>>> inside the stbuf_read_sysmd_field(), and the code is simpler IMHO.
>>>
>>> Any comments?
>>
>> BUILD_BUG_ON() requires a function, but it is still
>> be possible to add a build time check in TD_SYSINFO_MAP
>> e.g.
>>
>> #define TD_SYSINFO_CHECK_SIZE(_field_id, _size)                       \
>>       __builtin_choose_expr(MD_FIELD_ELE_SIZE(_field_id) == _size, _size, (void)0)
>>
>> #define _TD_SYSINFO_MAP(_field_id, _offset, _size)            \
>>       { .field_id = _field_id,                                \
>>         .offset   = _offset,                                  \
>>         .size     = TD_SYSINFO_CHECK_SIZE(_field_id, _size) }
>>
>> #define TD_SYSINFO_MAP(_field_id, _struct, _member)           \
>>       _TD_SYSINFO_MAP(MD_FIELD_ID_##_field_id,                \
>>                       offsetof(_struct, _member),             \
>>                       sizeof(typeof(((_struct *)0)->_member)))
>>
>>
> 
> Thanks for the comment, but I don't think this meets for our purpose.
> 
> We want a build time "error" when the "MD_FIELD_ELE_SIZE(_field_id) == _size"
> fails, but not "still initializing the size to 0".

FWIW, it isn't 0, it is void.  Assignment to void is an error.  Could use
anything that is correct syntax but would produce a compile-time error
e.g. (1 / 0).

> Otherwise, we might get
> some unexpected issue (due to size is 0) at runtime, which is worse IMHO than
> a runtime check as done in the current upstream code.
> 
> I have been trying to add a BUILD_BUG_ON() to the field_mapping structure
> initializer, but I haven't found a reliable way to do so.
> 
> For now I have completed the new version based on Dan's suggestion, but still
> need to work on changelog/coverletter etc, so I think I can send the new
> version out and see whether people like it.  We can revert back if that's not
> what people want.


