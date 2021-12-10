Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B0946FD4F
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238982AbhLJJHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbhLJJHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:07:08 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91F3C061746;
        Fri, 10 Dec 2021 01:03:32 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id t5so27377081edd.0;
        Fri, 10 Dec 2021 01:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3FhQRn6t8CnGm+vKU1e4eaK8F5RiVgOk+ZEYVd6jVTM=;
        b=MpTX4LIwGQOk64FZlR6Zm9XEzTqOFKolkPdBF+LiCd75PUsR+0GwBeTagC7UH6vKpn
         CuePmEhBSfHLPhrPm5mK/CggS4fNvntR+2Qch+lu1rJ1fnRln/yhJYEF5eUV5X2EEEAh
         LBya7WX/F8E1YTXgYsW8OqF5wwQOq3HgIyFKDlvg7nf9blT1i2i03fFZCJqkI4Hd0dPg
         ipM4/UqYopjgkhYqloF7xnymsqQzevLiU9L3wAoZ/jis/zkRsT+0+MNUKhto4KEKxcgN
         pea891DQvu53K2rM0CTrRR0Y1U7n5PcUvLNQdzbTWC8KFUdgjw7n9G4n+GMRNnzChWdp
         zCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3FhQRn6t8CnGm+vKU1e4eaK8F5RiVgOk+ZEYVd6jVTM=;
        b=cKGCNhA8LeC/IwAiy1z55S3Sh49teObg8r9U+aEX2SWrjkgIcCNTXAMBoiTfkeEIXo
         75vF8PY5Uw99GSizoxOO/aLCmjuZAyzaszNYrgZmqF3o8oCoOpWrjYaFrLUM6AemWwxT
         6INv9nCtGUCN9XrOQWtCH8sgziAuwXqWWSkesppqzaM5B3y6YwB7Dmt1/Qb6oTGciyoI
         2UyeteOdd78tpb1VB9NqBrhjwVe8wV3L7wjL7s5rX6ALV/WcdOdTdpp96YKZ/dso/c/b
         sjyUQl7cKXpaZQSZFVejlR6Zm3iagXOJjYNzEkoJ2UEyMSwPshe23oA/jNSDvcNE0bc8
         EPoQ==
X-Gm-Message-State: AOAM533EIXRzeU5STD2+42RdlpTmH357LD34qCchJuEeyNZfcVnqvMzd
        s70W7NwMqk8sAPakTiRje4M=
X-Google-Smtp-Source: ABdhPJzbezQ2Rr+2pGhWX7CsmpDgEjqbq16zGPlBm/PJ97py4CtdwygoIL3va5fk2KKHjCfVJxIHSA==
X-Received: by 2002:a05:6402:2814:: with SMTP id h20mr36690640ede.288.1639127011582;
        Fri, 10 Dec 2021 01:03:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id y19sm1144393edc.17.2021.12.10.01.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 01:03:31 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <95bf3dca-c6d1-02c8-40b6-8bb29a3a7a36@redhat.com>
Date:   Fri, 10 Dec 2021 10:03:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86: avoid out of bounds indices for fixed
 performance counters
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     jmattson@google.com, wanpengli@tencent.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
References: <20211209191101.288041-1-pbonzini@redhat.com>
 <7a2fc1d7-6ef4-cf4c-5ba0-c0eaefd2c66b@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <7a2fc1d7-6ef4-cf4c-5ba0-c0eaefd2c66b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 09:59, Like Xu wrote:
> 
> How about introducing a static "struct x86_pmu_capability" variable [1] 
> so that we can
> 
> (1) setup num_counters_fixed just once in the kvm_init_pmu_capability(), 
> and
> (2) avoid repeated calls to perf_get_x86_pmu_capability() ;

Yes, that works.

> [1] 
> https://lore.kernel.org/kvm/20210806133802.3528-17-lingshan.zhu@intel.com/
> By the way, do you need a re-based version of the guest PBES feature ?

Sure, please send one.

Paolo
