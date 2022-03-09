Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE724D3221
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 16:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiCIPuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 10:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiCIPuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 10:50:00 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36C3125596;
        Wed,  9 Mar 2022 07:49:00 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id i8so3706281wrr.8;
        Wed, 09 Mar 2022 07:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UvDQvGGIQNW5MaHyS/mnG9zXoZoWfvzFCfxk1NpxBYw=;
        b=CcVPysRDYi8j3ctN8YzvtcUss+rDJ2vKmjgyTLQnNfjenE/Jlwrup2sEjWJOXA2GaV
         6hvXN4difWnS/0zowY2Cdb4rImh8gMkpp5Z8ez3kus63CA8dzBCmidsDAIi6lQO52R8V
         h5LwyK+boyIe7k8w9efHEeqbpeIU8HTMKM3K2lb+WNAO6AkriFsCoUF6zcZUHqKbxjYs
         sHioM2Oj1ajNVREpqz7r0+oT6mTqoTawCzCUeOPilv6otCaKiiBZx3Zsh0VHMmK5PqwF
         SsKrHaIa0CALRWHJTamhMWFaZP3ysJrfiz3sb0lwPccCZ7OGkN4frFeFjdprTGdI/mn+
         davA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UvDQvGGIQNW5MaHyS/mnG9zXoZoWfvzFCfxk1NpxBYw=;
        b=D9YYsPF+y0fom608rDRNhYEl77IBucOsLVkloLUOUaBsUR3yaOUMqZFg9HDIyiiaPu
         4zExmGDWTk510QB5p1ewpW8U+awX0tecyZKqerYDjizbyGshUrhn38H1ZZK15/h/aQq4
         veeVPY7S1q//M17XviUfi1Fxge7MfUMAUxJ+Wl9pyGqjDJ2B9TfPX2sCsNQ4F3Y7hVNW
         XkahPn9DdIzaxP5Cqaag+65sswXP5yd4GtlclhLFF6uRl5NxqwqfStl4c7PrmY87jIWY
         rob5v/Niq6hBohr1h52NYDwDvQ5tM/i/qvGamSJ7YrpniAddcIxGh7FkA1suXqTCjrUy
         8qOQ==
X-Gm-Message-State: AOAM5314ES1APcC+KR9ZD0x2mdtJzPdS0o73gQ7JHup/lgbKzTud1+NX
        L67P49KoaTTkGRx4n5rBxhc=
X-Google-Smtp-Source: ABdhPJyr+cM08kKU/CwDU8NZtSv7ZhRJzVPiemZJOIz4CeQxecTPaoie8n/274SyjwZN4Hd3o3ToYQ==
X-Received: by 2002:adf:eb81:0:b0:1e3:2bf5:132 with SMTP id t1-20020adfeb81000000b001e32bf50132mr209876wrn.246.1646840939149;
        Wed, 09 Mar 2022 07:48:59 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h12-20020a5d548c000000b001f1f99e7792sm1893101wrv.111.2022.03.09.07.48.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 07:48:58 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7b1999d1-4fd7-1b59-76f7-4287ad2c2a99@redhat.com>
Date:   Wed, 9 Mar 2022 16:48:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 3/4] KVM: x86: SVM: use vmcb01 in avic_init_vmcb
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-4-mlevitsk@redhat.com> <Yh5H8qRhbefuD9YF@google.com>
 <603d78c516d10119c833ff54367b63b7a66f32b3.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <603d78c516d10119c833ff54367b63b7a66f32b3.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 18:25, Maxim Levitsky wrote:
>> I don't like this change.  It's not bad code, but it'll be confusing because it
>> implies that it's legal for svm->vmcb to be something other than svm->vmcb01.ptr
>> when this is called.
> Honestly I don't see how you had reached this conclusion.
>   
> I just think that code that always works on vmcb01
> should use it, even if it happens that vmcb == vmcb01.
>   
> If you insist I can drop this patch or add WARN_ON instead,
> I just think that this way is cleaner.
>   

I do like the patch, but you should do the same in init_vmcb() and 
svm_hv_init_vmcb() as well.

Paolo
