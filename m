Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EC63A8345
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 16:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhFOOz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 10:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhFOOz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 10:55:27 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DBEC06175F
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 07:53:23 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e33so6934550pgm.3
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 07:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f+mb8hE5qEI8SFYdKsdXmbC7vnzJ890l7d6jep5B66Y=;
        b=LYh/29XOkqDQNUxW1cp+diIVw/W6KBSo0Tt0wzhVafr9ep70jVeKOqGPOmVZyi8LNI
         YU+ZmHf+sdXXG0BvM3oihR5dZbZmc+gKejJC7bNHHV3046IM6W4GzWJZPMOFuS/PGQOi
         NHdh3swAubUq5MwD5q7yaSEUMLGgmCCUkj97MUYAaT5wVOEtoGBr0NCL1sK0M1wlC8cH
         Pwn0IB8ttE8UCiWt2utkOCjJnXCycYY1rv0gMV16iVT+MU2Ks2F3fmTIXv7Rheew4TCp
         SbTCwp0p8fE2FLjvExh/vs06HiOnvfpV06OVgCUSX0nnF1hZ3KNopdcz/Dcz700GwJk2
         6WgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f+mb8hE5qEI8SFYdKsdXmbC7vnzJ890l7d6jep5B66Y=;
        b=t19lEKFTsm5UWtn2mVj51ug0hPA7XdWwhI6788e2WJJNHfRa2MPwKu7t86hc3UreTK
         krOMAmuNcdgzYos33OAnDqI35WosQ4ojPTwGHlL/UI4i5OS8QePO3rE8oqZnJIH608ZB
         uW0zaB5Botk2DTew+YAW29OMKK1gcq2mmOsotZ/3lZEvCdmqnAH2M0XJr17+06CPIwXw
         K+V6AfuJYZUHX9ZSN5AVC5qt5XLaAZ7fbjwob6D4dNQw1o8k7HrKyYcsKDGiPdgCX5E9
         uVeKYUHcxiLgTiplObt4bE2N+OW+uSeeAZkLeQe2bkk/h66c0xjUZJ4Oq2MRkyOPaBTz
         47wQ==
X-Gm-Message-State: AOAM533wYqaYdGIU5QClRtdfyFXpxxmL2/gt0P42q+YZuSkY3a97NoQU
        Q6+6zuOUs2WR4q3/C/348OGZog==
X-Google-Smtp-Source: ABdhPJwOAV4Cy4XCSyqnDXDu9WbAj0nWVCvnYftwqVtM4oOSh2fUoWF3gKPbJ5G7kIYo+Yruveq+gA==
X-Received: by 2002:a63:2ac4:: with SMTP id q187mr22527029pgq.370.1623768799808;
        Tue, 15 Jun 2021 07:53:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gf10sm15331746pjb.35.2021.06.15.07.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:53:19 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:53:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: hyper-v: housekeeping: Remove unnecessary type cast
Message-ID: <YMi+2z+v6YLY/P55@google.com>
References: <20210603132712.518-1-sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603132712.518-1-sidcha@amazon.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021, Siddharth Chandrasekaran wrote:
> Remove unnecessary type cast of 'u8 instructions[]' to
> 'unsigned char *'.
> 
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
