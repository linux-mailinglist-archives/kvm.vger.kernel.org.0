Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABD675ADA6
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 13:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjGTL7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 07:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjGTL7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 07:59:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E815AC
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 04:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689854300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0dNgYkR9W7VbSPxZGAcgSDALg6OyW+ZsaC5VGkZKv2Q=;
        b=dFdJt0PX6Y7WngPZC8pW9LyTvkNkiZhgGQjRHSDQBF7O4gHSlXPak3Coko/ykr1P1Cf1kP
        lUVX87BvB1ht4eXOnsTRLQ04O7vt2y/7stHMVDDwfjd+ks1UR7+eBtkLOoNnuP1ew6UC9B
        qH9x7W3KkL0Z84RrbinSZwGENTWBobo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-D4-Cq_saMESUfYO8tvAtlA-1; Thu, 20 Jul 2023 07:58:19 -0400
X-MC-Unique: D4-Cq_saMESUfYO8tvAtlA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1b83410b5b6so919005ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 04:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689854298; x=1690459098;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0dNgYkR9W7VbSPxZGAcgSDALg6OyW+ZsaC5VGkZKv2Q=;
        b=F/698ICr82/uZJA2+BhMq4EB6wswTeEW4FcerGyIwNeWhu6KuY6ll+16MfMlubN+DE
         wZ6kxoTn7voMbvSsAjLfpKVqORc2Ozq4zVS5DQopxvkXmH2/hCRpNIPTJqbMKnRTHB5h
         zRyQEPQ6Ssk13RmG4iIi77e/C0+0PGH49GxYOsnWjmGDGB/h7K5CHWRws/IOoIGVT1S2
         1qOI2/jZ5VsbKjt5wmQiIuU6N2KOAtiZv3NnwoSSWBbvxBQLeG0kBhbRH7m+Qed58z95
         AEd3qxJ1qt1i/cRoQreZs+jeqIkiHQtefp8z2rOw+MMEExl1vq8B+h5b838ZZZa/C24K
         mE5A==
X-Gm-Message-State: ABy/qLbzLSv9ONvKoC2iLGlZaKpei3KJiyfaucMsnjzLc+VwTGxpJNtg
        pyU5ZbmTT/756oMPh2gB5hUhWRo1QrWW6+rymMS/4hLBENvEw7BpzZARnlufJeYGw8TbSYnHqA5
        0SYMluPq8h4gNpww7+TYo9/kskw==
X-Received: by 2002:a17:902:d50e:b0:1b8:811:b079 with SMTP id b14-20020a170902d50e00b001b80811b079mr3135249plg.0.1689854298355;
        Thu, 20 Jul 2023 04:58:18 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGjBq2vTMir1cBsPHCjdcjF3pXZv3IdwkvYZkbkcoa2SqoyCuxpuAvOR6jX0+7TBeGFOEuucg==
X-Received: by 2002:a17:902:d50e:b0:1b8:811:b079 with SMTP id b14-20020a170902d50e00b001b80811b079mr3135227plg.0.1689854298032;
        Thu, 20 Jul 2023 04:58:18 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d17-20020a170902c19100b001b9e1d5f8e0sm1176040pld.91.2023.07.20.04.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 04:58:17 -0700 (PDT)
Message-ID: <0a2dab13-b7ea-7621-00d9-7af2b17aa5ce@redhat.com>
Date:   Thu, 20 Jul 2023 19:58:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH v1 2/2] arm64: Define name for the bits
 used in SCTLR_EL1_RES1
Content-Language: en-US
To:     eric.auger@redhat.com, andrew.jones@linux.dev
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20230719031926.752931-1-shahuang@redhat.com>
 <20230719031926.752931-3-shahuang@redhat.com>
 <433bb06d-5eaa-d21f-70c8-02311c06a650@redhat.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <433bb06d-5eaa-d21f-70c8-02311c06a650@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 7/20/23 01:46, Eric Auger wrote:
> Hi Shaoqin,
> 
> On 7/19/23 05:19, Shaoqin Huang wrote:
>> Currently some fields in SCTLR_EL1 don't define a name and directly used
>> in the SCTLR_EL1_RES1, that's not good now since these fields have been
>> functional and have a name.
>>
>> According to the ARM DDI 0487J.a, define the name related to these
>> fields.
>>
>> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   lib/arm64/asm/sysreg.h | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
>> index c7f529d..9c68698 100644
>> --- a/lib/arm64/asm/sysreg.h
>> +++ b/lib/arm64/asm/sysreg.h
>> @@ -80,17 +80,26 @@ asm(
>>   #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>>   
>>   /* System Control Register (SCTLR_EL1) bits */
>> +#define SCTLR_EL1_LSMAOE	_BITUL(29)
>> +#define SCTLR_EL1_NTLSMD	_BITUL(28)
>>   #define SCTLR_EL1_EE		_BITUL(25)
>> +#define SCTLR_EL1_SPAN		_BITUL(23)
>> +#define SCTLR_EL1_EIS		_BITUL(22)
>> +#define SCTLR_EL1_TSCXT		_BITUL(20)
>>   #define SCTLR_EL1_WXN		_BITUL(19)
>>   #define SCTLR_EL1_I		_BITUL(12)
>> +#define SCTLR_EL1_EOS		_BITUL(11)
>> +#define SCTLR_EL1_SED		_BITUL(8)
>> +#define SCTLR_EL1_ITD		_BITUL(7)
>>   #define SCTLR_EL1_SA0		_BITUL(4)
>>   #define SCTLR_EL1_SA		_BITUL(3)
>>   #define SCTLR_EL1_C		_BITUL(2)
>>   #define SCTLR_EL1_A		_BITUL(1)
>>   #define SCTLR_EL1_M		_BITUL(0)
>>   
>> -#define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
>> -			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
>> +#define SCTLR_EL1_RES1	(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
>> +			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
>> +			 SCTLR_EL1_NTLSMD | SCTLR_EL1_LSMAOE)
>>   #define INIT_SCTLR_EL1_MMU_OFF	\
>>   			SCTLR_EL1_RES1
>>   
> The change looks good to me (although _BITULL remark still holds).
> 
> Independently on this patch the _RES1 terminology looks odd to me. For
> example ESO bit is RES1 only if FEAT_ExS is not implemented. Maybe I
> misunderstand why it was named that way but to me RES1 means another
> thing. If confirmed we could simply drop SCTLR_EL1_RES1 which is not
> used elsewhere and directly define INIT_SCTLR_EL1_MMU_OF.

The SCTLR_EL1_RES1 was originally defined by commit 10b65ce ("arm64: 
Configure SCTLR_EL1 at boot"). It seems at that time the BIT(11), yes 
the EOS bit is undefined, and must be reserved for 1, but now it has a 
definition which is EOS. It should have no effect if set EOS bit to 1 
since its originally res to 1.

SCTLR_EL1_RES1 can simply be dropped since it has no other user.

Thanks,
Shaoqin

> 
> Thanks
> 
> Eric
> 

-- 
Shaoqin

