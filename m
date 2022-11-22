Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8976F63365F
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 08:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiKVHxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 02:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiKVHxo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 02:53:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C85FBF5C
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 23:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669103564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rifkp7obcWWXPx9xWSCjpQuWQ7gvbRTBtiWo8m0gkU0=;
        b=Jm21awnX4dzz7gWFAblruH4ez1kou6VMVhaAro5k+difkiJ6yvImiIzQ365RUqoNlbXSI6
        Xkv390ccHrG/+rBOepDXyp2nDI9st7B+KqS1t9WtfWXDeEzfTPW/AMxnHrlrt5JFGYKQ7m
        AMQBPGVNC+Lnoy1ZKBsLSh0axVSK16A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-587-Mp-GT5_nNcaGRgAmJ7JZfg-1; Tue, 22 Nov 2022 02:52:42 -0500
X-MC-Unique: Mp-GT5_nNcaGRgAmJ7JZfg-1
Received: by mail-wm1-f69.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso7682494wms.8
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 23:52:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rifkp7obcWWXPx9xWSCjpQuWQ7gvbRTBtiWo8m0gkU0=;
        b=kJgbAV0o9Ib3Xhq37duKm85340qp9SCnfDamD+dwZ19vEPrfLCwRBwRCKs/kXys5bB
         AbLUq72hHuT5JHZ0Oz8vz/9y+fipeqdH8E0+Z8y8QP3e88V1YRSLU96bWJ2ak53v8+WU
         FLnu0KUVB9JiD07WyJJet5QzEMkt6N240UqpxYvrmZbgchxcB1lsNUtT6Galkg/vX+dR
         W6Q3NI6fjgbmFMY5tEXJVpYJ6jZAulKU5kfC0iIIxuMfxs7p28PmB0LGBfdbmqY30XBX
         CtbQAcxshyOdfeXzGNh2ruoyCvi7Kxfnm23Q0Jf9V/vQsYyqiXXd5UrAfw/GleZEYH0O
         9drw==
X-Gm-Message-State: ANoB5pmxm3ocvcGPpnGBKhpBLzT7ROMk2pDSjBsSPyAqZXP57yNUgZXu
        otgTZQNTwFWUfWORE9diFdOcU+VgVkiTvo8C2bHc0H7+/JDb+Fr4wIyNkL1vOgJTSvZ0yxqpb4b
        XQXAdza0f4Wxu
X-Received: by 2002:adf:fb46:0:b0:22e:2d49:7d3d with SMTP id c6-20020adffb46000000b0022e2d497d3dmr2580798wrs.505.1669103561384;
        Mon, 21 Nov 2022 23:52:41 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6dCyiCr/pA3VX12HcFTwn/lzvVTWMeppWH7T0RHoLOGqWKUNNg5K+8qhkBYZB35FlJdUiQ9w==
X-Received: by 2002:adf:fb46:0:b0:22e:2d49:7d3d with SMTP id c6-20020adffb46000000b0022e2d497d3dmr2580781wrs.505.1669103561123;
        Mon, 21 Nov 2022 23:52:41 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-176-72.web.vodafone.de. [109.43.176.72])
        by smtp.gmail.com with ESMTPSA id b14-20020a5d4d8e000000b0022cbf4cda62sm15603451wru.27.2022.11.21.23.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 23:52:40 -0800 (PST)
Message-ID: <c801611e-61db-73d2-2ff1-cd06350215b2@redhat.com>
Date:   Tue, 22 Nov 2022 08:52:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 5/9] KVM: s390: selftest: memop: Move testlist into
 main
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20221117221758.66326-1-scgl@linux.ibm.com>
 <20221117221758.66326-6-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221117221758.66326-6-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/11/2022 23.17, Janis Schoetterl-Glausch wrote:
> This allows checking if the necessary requirements for a test case are
> met via an arbitrary expression. In particular, it is easy to check if
> certain bits are set in the memop extension capability.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   tools/testing/selftests/kvm/s390x/memop.c | 132 +++++++++++-----------
>   1 file changed, 66 insertions(+), 66 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
> index 286185a59238..10f34c629cac 100644
> --- a/tools/testing/selftests/kvm/s390x/memop.c
> +++ b/tools/testing/selftests/kvm/s390x/memop.c
> @@ -690,87 +690,87 @@ static void test_errors(void)
>   	kvm_vm_free(t.kvm_vm);
>   }
>   
> -struct testdef {
> -	const char *name;
> -	void (*test)(void);
> -	int extension;
> -} testlist[] = {
> -	{
> -		.name = "simple copy",
> -		.test = test_copy,
> -	},
> -	{
> -		.name = "generic error checks",
> -		.test = test_errors,
> -	},
> -	{
> -		.name = "copy with storage keys",
> -		.test = test_copy_key,
> -		.extension = 1,
> -	},
> -	{
> -		.name = "copy with key storage protection override",
> -		.test = test_copy_key_storage_prot_override,
> -		.extension = 1,
> -	},
> -	{
> -		.name = "copy with key fetch protection",
> -		.test = test_copy_key_fetch_prot,
> -		.extension = 1,
> -	},
> -	{
> -		.name = "copy with key fetch protection override",
> -		.test = test_copy_key_fetch_prot_override,
> -		.extension = 1,
> -	},
> -	{
> -		.name = "error checks with key",
> -		.test = test_errors_key,
> -		.extension = 1,
> -	},
> -	{
> -		.name = "termination",
> -		.test = test_termination,
> -		.extension = 1,
> -	},
> -	{
> -		.name = "error checks with key storage protection override",
> -		.test = test_errors_key_storage_prot_override,
> -		.extension = 1,
> -	},
> -	{
> -		.name = "error checks without key fetch prot override",
> -		.test = test_errors_key_fetch_prot_override_not_enabled,
> -		.extension = 1,
> -	},
> -	{
> -		.name = "error checks with key fetch prot override",
> -		.test = test_errors_key_fetch_prot_override_enabled,
> -		.extension = 1,
> -	},
> -};
>   
>   int main(int argc, char *argv[])
>   {
>   	int extension_cap, idx;
>   
> +	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
>   	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_MEM_OP));
> +	extension_cap = kvm_check_cap(KVM_CAP_S390_MEM_OP_EXTENSION);
>   
> -	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
> +	struct testdef {
> +		const char *name;
> +		void (*test)(void);
> +		bool requirements_met;
> +	} testlist[] = {
> +		{
> +			.name = "simple copy",
> +			.test = test_copy,
> +			.requirements_met = true,
> +		},
> +		{
> +			.name = "generic error checks",
> +			.test = test_errors,
> +			.requirements_met = true,
> +		},
> +		{
> +			.name = "copy with storage keys",
> +			.test = test_copy_key,
> +			.requirements_met = extension_cap > 0,
> +		},
> +		{
> +			.name = "copy with key storage protection override",
> +			.test = test_copy_key_storage_prot_override,
> +			.requirements_met = extension_cap > 0,
> +		},
> +		{
> +			.name = "copy with key fetch protection",
> +			.test = test_copy_key_fetch_prot,
> +			.requirements_met = extension_cap > 0,
> +		},
> +		{
> +			.name = "copy with key fetch protection override",
> +			.test = test_copy_key_fetch_prot_override,
> +			.requirements_met = extension_cap > 0,
> +		},
> +		{
> +			.name = "error checks with key",
> +			.test = test_errors_key,
> +			.requirements_met = extension_cap > 0,
> +		},
> +		{
> +			.name = "termination",
> +			.test = test_termination,
> +			.requirements_met = extension_cap > 0,
> +		},
> +		{
> +			.name = "error checks with key storage protection override",
> +			.test = test_errors_key_storage_prot_override,
> +			.requirements_met = extension_cap > 0,
> +		},
> +		{
> +			.name = "error checks without key fetch prot override",
> +			.test = test_errors_key_fetch_prot_override_not_enabled,
> +			.requirements_met = extension_cap > 0,
> +		},
> +		{
> +			.name = "error checks with key fetch prot override",
> +			.test = test_errors_key_fetch_prot_override_enabled,
> +			.requirements_met = extension_cap > 0,

I wonder whether it would rather make sense to check for "extension_cap & 1" 
instead of "extension_cap > 0" ?

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>

