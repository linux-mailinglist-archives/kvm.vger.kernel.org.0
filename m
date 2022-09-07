Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5CD5B0980
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 18:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiIGQBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 12:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiIGQAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 12:00:39 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C037598369
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 09:00:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m3so4398872pjo.1
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 09:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=PL/6JU5/S/Tf9t3nW0OZ+zGEXKtZtWIWZJ+MGwDWvKo=;
        b=s5UCZOMsmd5CJ/0ibgGJoBMIhIOKHPfxUqfLFaw0BrWFbR/vCSFUO4H2XJfXJ0RC1E
         6mrliQVV4WgBaaMwtK+qAeQA2v5jWr6H145fYBtxg9M+pCbQRWCjufsGfAsZIiblZWQb
         2stqcyKY70rBuZrftxCGmMLFAO9ookNLT4cdrLKnQjVkeMHuRO+VnM4RUTLrZfraQg4A
         GoBJzRZUs4G9ARpJvd8mnJFunPi0NMNhk/XZeJmFkdrf75jyz8x/iNMFa7hoFFEJTDqF
         vWNpPFpA3HYTUMwtmcaYsHv6PUL66X+kvzvjKFUz1REJ9DxARePelhu+KA89fJJ+Drsc
         p2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=PL/6JU5/S/Tf9t3nW0OZ+zGEXKtZtWIWZJ+MGwDWvKo=;
        b=U5MYs3TiRzKNSN5sRHhMJYgISmkXx/J8T6ltI3zl6Rxe57eroRKyyCwq5yfIFKSbGp
         KsJoliBUo5K2hkeh+b+WcILLAiG2m0GPgtVG5a5pb2l1Dv1Hq4T79v/iT0eniPeCiIWi
         RoTeYaYj2597K+rj1oXze7OtahhDhX/qc7y/uBs8hx5E4AnfVjKD/sA5qCL/mPG0MKX1
         nNN76hu/Ftn1IrF+0RhOYqmDzxBf3xCnCyL/0ITmkjcUo/+S9Y4BgFsTC3A2byDzqGEY
         fRyL/MfI+qQLHTNYN7BXERBzeJBFkzwgyxgJK7YAKWYUiPoawR0/MFUkcCsHLevUpQJx
         9uvw==
X-Gm-Message-State: ACgBeo2yZBIbb5PzlY2QP0trVBBAxf8jf8Afn3y/m72oVKIt7rUZWB+K
        5HCDg7AWcWO+eVmRVDO6CJR9BQ==
X-Google-Smtp-Source: AA6agR56CQhwCqSpoZP4Zph0Vr2bsCdeyy0cU2fY/92R2g5nd3RRETckjU1gFJlsT743h83Hf+KK0w==
X-Received: by 2002:a17:902:d2cd:b0:177:4940:cc03 with SMTP id n13-20020a170902d2cd00b001774940cc03mr2886666plc.98.1662566408299;
        Wed, 07 Sep 2022 09:00:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a16-20020a621a10000000b00537a6b81bb7sm13147646pfa.148.2022.09.07.09.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 09:00:07 -0700 (PDT)
Date:   Wed, 7 Sep 2022 16:00:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Liam Merwick <liam.merwick@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        pbonzini@redhat.com, gshan@redhat.com, oliver.upton@linux.dev,
        andrew.jones@linux.dev
Subject: Re: [PATCH] KVM: selftests: Make rseq compatible with versions prior
 to glibc-2.30
Message-ID: <YxjABH3Fw7W+NE8J@google.com>
References: <20220907155510.968666-1-liam.merwick@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907155510.968666-1-liam.merwick@oracle.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022, Liam Merwick wrote:
> The fix for commit e923b0537d28 ("KVM: selftests: Fix target thread to be migrated in rseq_test")
> added a call to gettid() which was only added to glibc-2.30 and fails to
> compile with older glibc versions.
> 
> rseq_test.c: In function 'main':
> rseq_test.c:230:33: warning: implicit declaration of function 'gettid'; did you mean 'getgid'? [-Wimplicit-function-declaration]
>           (void *)(unsigned long)gettid());
>                                  ^~~~~~
>                                  getgid
> 
> Switch the call to syscall(SYS_gettid) which was the original advice in the
> gettid(2) NOTES section and which works with both new and older glibc versions.
> 
> Fixes: e923b0537d28 ("KVM: selftests: Fix target thread to be migrated in rseq_test")
> Cc: stable@vger.kernel.org # v5.15
> Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
> ---
> 
> Verified with glibc-2.28 and glibc-2.34 and ensured test case from e923b0537d28 still passes.
> 
>  tools/testing/selftests/kvm/rseq_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index fac248a43666..6f88da7e60be 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -227,7 +227,7 @@ int main(int argc, char *argv[])
>  	ucall_init(vm, NULL);
>  
>  	pthread_create(&migration_thread, NULL, migration_worker,
> -		       (void *)(unsigned long)gettid());
> +		       (void *)(unsigned long)syscall(SYS_gettid));

This exact fix was already posted[*], but we rat-holed a bit on coming up with an
elegant solution and the patch never got applied.  I'll poke that thread to see if
Paolo wants to take it for 6.0.

[*] https://lore.kernel.org/all/20220802071240.84626-1-cloudliang@tencent.com
