Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86E66403CF
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 10:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiLBJyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 04:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiLBJye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 04:54:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37EA13CD4
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 01:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669974817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ru04HJY0/sUrvpqNNRBgbFI0lObnkjMIBMlPJpqQ7AY=;
        b=hdCCpLK1hvsm0RaE94xj0tAuyl3QSsrCpYa6YF/zMDxgRQIpfU7UVv2j6xvszc9tmPV9p5
        Pmd1xcQe2zQmkUPsnLaxOUpe15+xieoyALdCXpaU8a5goqUHtphQT+UdawnkvJh9XAeZBn
        jIaZkQZUAI/QB7mZUb3B6uCs/sWd9c4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-227-oSOPQbwHNVm9AOTNGzAnMg-1; Fri, 02 Dec 2022 04:53:33 -0500
X-MC-Unique: oSOPQbwHNVm9AOTNGzAnMg-1
Received: by mail-wm1-f69.google.com with SMTP id v125-20020a1cac83000000b003cfa148576dso2259997wme.3
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 01:53:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ru04HJY0/sUrvpqNNRBgbFI0lObnkjMIBMlPJpqQ7AY=;
        b=WgJoflzDWGXfNr3o/j4zfOTprNc905+jKoqbMaawhYvfV6SnL2t7piztAbneZO2T+y
         bCAGwfNT40mGUI1hYEpuFuusBlRL0WVH1fH2iRBp6+XvRDRo7H7P+4S+wBkCn1whpCo1
         zJQVMaBF37ct7033hND+q3/ORq6aIJnCEjWjr4w0UllToyDss9UnLPog2/+kkIVp2THn
         teLClSiujL32jrsJKc4KU7f6pQ6klffUoO2Z0lWbjYPfGAcciTrYw5C5zlqS1OD1YQaD
         6jj0GosI8iC8M+4cue7Rbk7mPzfcRFUJAAIb2s/Y3QrOYmh59dgLZHZM/6e2JkPNIoHJ
         yuUg==
X-Gm-Message-State: ANoB5pmRTpqa/WnJ+zUgHV+Xgf868aEd8vfO9NAQb4fk2TtKdBsp2Dx6
        H8jbjjXcaMXE/3kXgQcWUxSNrPmd1o86wRw/AckdgbwD4uKg1mHRmpTGBbKSh3ZAGPOHoerBysL
        qdtLhDwj9u7+1
X-Received: by 2002:a05:600c:210c:b0:3cf:6af4:c4fa with SMTP id u12-20020a05600c210c00b003cf6af4c4famr52488255wml.117.1669974812118;
        Fri, 02 Dec 2022 01:53:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf65BBWtYBjaEEIV4Rmc22qKaaHF5pS/UbOyaHVEzKjCu0LYUKWxeR0A0bOrwXrH2IfmoWeKtg==
X-Received: by 2002:a05:600c:210c:b0:3cf:6af4:c4fa with SMTP id u12-20020a05600c210c00b003cf6af4c4famr52488249wml.117.1669974811912;
        Fri, 02 Dec 2022 01:53:31 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id j13-20020a056000124d00b002421db5f279sm6407552wrx.78.2022.12.02.01.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 01:53:31 -0800 (PST)
Message-ID: <beda4e26-6b18-66b4-efb7-c63ad4c5153d@redhat.com>
Date:   Fri, 2 Dec 2022 10:53:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 20/27] svm: move v2 tests run into
 test_run
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
 <20221122161152.293072-21-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-21-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> Move v2 tests running into test_run which allows to have code that runs the
> test in one place and allows to run v2 tests on a non 0 vCPU if needed.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---

Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

>  x86/svm.c | 33 +++++++++++++++++++--------------
>  1 file changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index 220bce66..2ab553a5 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -106,6 +106,13 @@ int svm_vmrun(void)
>  
>  static noinline void test_run(struct svm_test *test)
>  {
> +	if (test->v2) {
> +		vmcb_ident(vmcb);
> +		v2_test = test;
> +		test->v2();
> +		return;
> +	}
> +
>  	cli();
>  	vmcb_ident(vmcb);
>  
> @@ -196,21 +203,19 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
>  			continue;
>  		if (svm_tests[i].supported && !svm_tests[i].supported())
>  			continue;
> -		if (svm_tests[i].v2 == NULL) {
> -			if (svm_tests[i].on_vcpu) {
> -				if (cpu_count() <= svm_tests[i].on_vcpu)
> -					continue;
> -				on_cpu_async(svm_tests[i].on_vcpu, (void *)test_run, &svm_tests[i]);
> -				while (!svm_tests[i].on_vcpu_done)
> -					cpu_relax();
> -			}
> -			else
> -				test_run(&svm_tests[i]);
> -		} else {
> -			vmcb_ident(vmcb);
> -			v2_test = &(svm_tests[i]);
> -			svm_tests[i].v2();
> +
> +		if (!svm_tests[i].on_vcpu) {
> +			test_run(&svm_tests[i]);
> +			continue;
>  		}
> +
> +		if (cpu_count() <= svm_tests[i].on_vcpu)
> +			continue;
> +
> +		on_cpu_async(svm_tests[i].on_vcpu, (void *)test_run, &svm_tests[i]);
> +
> +		while (!svm_tests[i].on_vcpu_done)
> +			cpu_relax();
>  	}
>  
>  	if (!matched)
> 

