Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DCB393A3E
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 02:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbhE1AaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 20:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbhE1AaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 20:30:16 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CDBC061574
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 17:28:41 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso1504722pjb.5
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 17:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I7wy99R89NcBY4kuPu7JFHQrrTyxSqc5+QStHaB/eUU=;
        b=tda8JphBgw5jUTht2VrzpvbblgBlHPLgA3xnHbpUUtFQj5cYEJIfAGND1LawcJHqXZ
         t6iw1s8vareTh+zcsT+FIAfvWEtwKf40lKNniQtL0gEUX+2XMoB7qmwn12KCELABYEc8
         sv6hxDh5H4ZgULvz7fKdhrwUKjG+nusz2yCFMhu7pIe0FFXu1BC00LnKjVLrT8yzDiV9
         nsy67CFHpjlh3hwatKuZCpEQb10MWcdTR2GbsFdPlaYQS2XjDiAAfdMyJGIuTd/PRI2x
         UyHHyU100te1VyBhEcvO4oupoPIch1h6AO6nwVDn7hh4U6ANCLJVG1ZJlo2ZU7zapRlK
         1BLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I7wy99R89NcBY4kuPu7JFHQrrTyxSqc5+QStHaB/eUU=;
        b=bsfsblC1VAs4mwDCh0nopsHWaXNm7FQMQmN25HoVfDPNLupbjFMKxw0bs1KegMeX/g
         7Hm6+F80XA2RrGVAmXmLrR1zBADRXNMji4r7rXER2Zvg0H05vJYu0fSg1K+slYMOET0j
         M8hghwKdM0lJPHWmf2iATsjVw0iRCQWSnw8BTa/tu4bJzr5xW0JcK0xcqCtAhlaxURWc
         lC0prZhvQHU9zPRBUJof4B4pqeEA2SF1mm3P8DuALm/MXWSkIngVDb9i8nxzIdy1TVv3
         +zMboAADDgsKEXpE+1cWO19pzARrQzMxCG8ZBRRCxaP0vUrRfO1SfIWreaq4nKotPiHO
         7Tfg==
X-Gm-Message-State: AOAM533s2xLl1OdUVDJ5rmzcOT9ZkyhXOBwNWpf7wk97qyNl3vTNHBHs
        GlPO8zKtf62blIovxQ8ozePBeg==
X-Google-Smtp-Source: ABdhPJzw4drT7C9GHtNuv8i4niDLo5ACJsDJ9OeneWGvOpOu4EAkz/8JH6tc9Od1aqrcDMQbqLZO8Q==
X-Received: by 2002:a17:90a:a013:: with SMTP id q19mr1331687pjp.29.1622161720673;
        Thu, 27 May 2021 17:28:40 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id pg5sm2585505pjb.28.2021.05.27.17.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 17:28:40 -0700 (PDT)
Date:   Fri, 28 May 2021 00:28:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v4 2/2] KVM: X86: Kill off ctxt->ud
Message-ID: <YLA5NFSGemfAOrMa@google.com>
References: <1622160097-37633-1-git-send-email-wanpengli@tencent.com>
 <1622160097-37633-2-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622160097-37633-2-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> ctxt->ud is consumed only by x86_decode_insn(), we can kill it off by 
> passing emulation_type to x86_decode_insn() and dropping ctxt->ud 
> altogether. Tracking that info in ctxt for literally one call is silly.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
