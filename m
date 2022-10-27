Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07D9610608
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiJ0W5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiJ0W5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:57:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A926B56CB
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:57:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d10so3222700pfh.6
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QSnbuv8cCQpEJYgO5tazrX2fO03/wPHPX8Mv0eoOlgo=;
        b=aymdhcBIX2Y5IS3X3zhGqu9WRIVuKVkqrnNoIibIOwmah2ZiilS6MEjH6eY6f9ry0v
         ZiBI4RhZmoJ0sdDpI0ERdb1vwXjE7i6ZHgFFj1C9lbOzRHa4gpqS1GVCNJUHEG+YAyCu
         zKAhFTQT/PGWTiNGV/iVeBWOEpC9GQkl0o9/j1JvtNnOXhlrfPrsDgPcNzMtXGCBOmA5
         od5LObG1qGtzookEy1/k9yTEE2xi3HouuljVdSgJT3HHo1xlPsMglQ8FwloEh8OXCcVH
         nFS8TWDDvEsQNOZybCAaBEf3XdgH82hMUlZYl2Te4XPzcnly0M6Q71ZQerldVpsvDNKd
         SjRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSnbuv8cCQpEJYgO5tazrX2fO03/wPHPX8Mv0eoOlgo=;
        b=PSA7bbpO9c58s+SpgDGqUd8pV8n9HqFI2NiRo3zuL5s32GrhN+zlR4tcNFVpLZC8vM
         Nyfy56TIQPkFWF7Ik5Z3w0u3TL/9+skls64e138yUccOZPVslQKovzUr8T5hcGAKsiYC
         Oax1l8y/US4vk5uZuS2vj9orC5W/v3xZg4OGATVZXC8fkZueOta3q4b0HQZs0zKdrSa1
         +TWJA/po/rFziRUCM0LFUwuJFSTwHzchnbmno9iCSFrAaozhST/7j+y03Ib64RWtXEt1
         33Q76hKBzy8HUSC64l9HQFX5HJck8CefH9Jpn5ZkvVdS4xHs97EZkywmNS/dTCVHUDLd
         9yug==
X-Gm-Message-State: ACrzQf1tXwGzsq5/uAfJzLX3yOy57v06HCv4imzuMiYMqXOeCAZznXSa
        k+AT4+M2yK87awriNCzOqEwCUg==
X-Google-Smtp-Source: AMsMyM7xhuzQdA7xkiQglnrvKQ1RcZlwaj7KMRhPh6cMXZxDTpZb9y9TzzHdAz4pQEJCMizKVJhQ8g==
X-Received: by 2002:a05:6a00:1304:b0:555:6d3f:1223 with SMTP id j4-20020a056a00130400b005556d3f1223mr52292637pfu.60.1666911421712;
        Thu, 27 Oct 2022 15:57:01 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902654900b001753654d9c5sm1706942pln.95.2022.10.27.15.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 15:57:01 -0700 (PDT)
Date:   Thu, 27 Oct 2022 22:56:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Rong Tao <rtoax@foxmail.com>, gg@google.com
Cc:     Rong Tao <rongtao@cestc.cn>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: vmx: Fix indentation coding style issue
Message-ID: <Y1sMuSqh+oY/XtjY@google.com>
References: <tencent_4D21B619F00AE966BD5DD2ABA4BC7A8F060A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_4D21B619F00AE966BD5DD2ABA4BC7A8F060A@qq.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM: VMX:, because I am incapable of case-insensitive searches ;-)

On Thu, Oct 20, 2022, Rong Tao wrote:
> From: Rong Tao <rongtao@cestc.cn>
> 
> Code indentation should use tabs where possible.
> 
> Signed-off-by: Rong Tao <rongtao@cestc.cn>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
