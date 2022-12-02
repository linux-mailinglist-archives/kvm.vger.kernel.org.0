Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B381640CBE
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiLBSAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbiLBSAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:00:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5B5E4672
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670003982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7SFAZk313dpi6NA+oKZjez1ADPjE0wpXWNcDiyU9LD4=;
        b=GSHhq2xSdLsydFNtF10Bk0zKy02qqxGetp7bDd/tlBDjUkDNEdE9KbAVNxjotyFHYFpsA0
        602vRUQqsDST+sO3PlxSQA/SF6rexP3TWLH3CKXzLIa5NUOEHXY2FXqtFp4ZVdoL3WQ2XX
        vMuE38/lVBudOK6dXm44VYZ0ep8FcqY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-623-74LDSYifMaCSXaEJQLOlLg-1; Fri, 02 Dec 2022 12:59:41 -0500
X-MC-Unique: 74LDSYifMaCSXaEJQLOlLg-1
Received: by mail-wm1-f72.google.com with SMTP id bi19-20020a05600c3d9300b003cf9d6c4016so4455605wmb.8
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:59:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7SFAZk313dpi6NA+oKZjez1ADPjE0wpXWNcDiyU9LD4=;
        b=OCbvEmdfiydZJDnAu62+kagKkuL+IKbVJzGzC4ta5qdSGX8OpGNSjCBDCNrPcJ3aHo
         9wlm2vH6q+801sOK52sgh7hrxbUEHnHuV+uu7GItZ+rqaWQ0nfbB6LBiuyQtxAlciK6b
         E0tZ5ZbIUyb8dI0yZ0RvRjyJ5wSfOgLSGqhAw5n0jGKe9Z2Bw21Jlg5FZTHpcivPAUs7
         tnGAFMnLdahNwKAmFayYfbE1cfrww8bjhbMpfCOEKD4WnqzARRo2zXIWcQd9nfQKxiWT
         zPKcIdKVIpXLnl0bJIbi0a7hmO1uAXc5gHhja/QBey9hxuDQFoJXAfP8S3eXmBlzgq3y
         KeiQ==
X-Gm-Message-State: ANoB5pl6XjeKAfomBNJfXtQryW2Rw6qLwxD9aXDo2UU/TNIpDRfOkLhj
        NBIHkQNwKtmzRrrNyvy/a35J1kjrxJC1tJweVMwk9lsjRt0p3mCnw3kBycuqD3SZjGatrfzO9LJ
        GwVA7qiXOmODL
X-Received: by 2002:a05:600c:ac1:b0:3c6:d18b:304b with SMTP id c1-20020a05600c0ac100b003c6d18b304bmr39783049wmr.142.1670003980098;
        Fri, 02 Dec 2022 09:59:40 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7xD/tI1ATcSLVQPl5NcLTvRuLfgnqBgvECboZJMjHZkg84j1ouMJFKegjQyGhvYtCr53xP9Q==
X-Received: by 2002:a05:600c:ac1:b0:3c6:d18b:304b with SMTP id c1-20020a05600c0ac100b003c6d18b304bmr39783037wmr.142.1670003979786;
        Fri, 02 Dec 2022 09:59:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id n19-20020a05600c305300b003cf6a55d8e8sm8497749wmh.7.2022.12.02.09.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 09:59:39 -0800 (PST)
Message-ID: <95d1b3b7-f96f-0208-3b35-91a53661abb7@redhat.com>
Date:   Fri, 2 Dec 2022 18:59:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM: selftests: Fixes for 6.2
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <Y4k/ajYqnHhwv6lA@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y4k/ajYqnHhwv6lA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 12/2/22 00:57, Sean Christopherson wrote:
> Please pull selftests fixes for 6.2.  Most of these are fixes for things
> that are sitting in kvm/queue.
> 
> Thanks!
> 
> 
> The following changes since commit df0bb47baa95aad133820b149851d5b94cbc6790:
> 
>    KVM: x86: fix uninitialized variable use on KVM_REQ_TRIPLE_FAULT (2022-11-30 11:50:39 -0500)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-x86/linux.git tags/kvm-selftests-6.2-2
> 
> for you to fetch changes up to 0c3265235fc17e78773025ed0ddc7c0324b6ed89:
> 
>    KVM: selftests: Define and use a custom static assert in lib headers (2022-12-01 15:31:46 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM selftests fixes for 6.2
> 
>   - Fix an inverted check in the access tracking perf test, and restore
>     support for asserting that there aren't too many idle pages when
>     running on bare metal.
> 
>   - Fix an ordering issue in the AMX test introduced by recent conversions
>     to use kvm_cpu_has(), and harden the code to guard against similar bugs
>     in the future.  Anything that tiggers caching of KVM's supported CPUID,
>     kvm_cpu_has() in this case, effectively hides opt-in XSAVE features if
>     the caching occurs before the test opts in via prctl().
> 
>   - Fix build errors that occur in certain setups (unsure exactly what is
>     unique about the problematic setup) due to glibc overriding
>     static_assert() to a variant that requires a custom message.
> 
> ----------------------------------------------------------------
> Lei Wang (1):
>        KVM: selftests: Move XFD CPUID checking out of __vm_xsave_require_permission()
> 
> Sean Christopherson (6):
>        KVM: selftests: Fix inverted "warning" in access tracking perf test
>        KVM: selftests: Restore assert for non-nested VMs in access tracking test
>        KVM: selftests: Move __vm_xsave_require_permission() below CPUID helpers
>        KVM: selftests: Disallow "get supported CPUID" before REQ_XCOMP_GUEST_PERM
>        KVM: selftests: Do kvm_cpu_has() checks before creating VM+vCPU
>        KVM: selftests: Define and use a custom static assert in lib headers
> 
>   tools/testing/selftests/kvm/access_tracking_perf_test.c | 22 ++++++++++++++--------
>   tools/testing/selftests/kvm/include/kvm_util_base.h     | 14 +++++++++++++-
>   tools/testing/selftests/kvm/include/x86_64/processor.h  | 23 ++++++++++++-----------
>   tools/testing/selftests/kvm/lib/x86_64/processor.c      | 84 ++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
>   tools/testing/selftests/kvm/x86_64/amx_test.c           | 11 ++++++++---
>   5 files changed, 91 insertions(+), 63 deletions(-)
> 

