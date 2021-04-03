Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5C4353375
	for <lists+kvm@lfdr.de>; Sat,  3 Apr 2021 12:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhDCKnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Apr 2021 06:43:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235604AbhDCKnl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Apr 2021 06:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617446618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=61f7oFHi8TAP6R3U20yKNfdx/rbT6AGQPs/+ynBgVBY=;
        b=WGWrotXFW7cZY0XTMnVwSzui8WBSfACQmWaM7IxEqDrzJb1cFjh2uBo3gBLWQ13d2fsNNu
        9rkCOpjJ1vYewsz8BQXcWoN0yvWMdQLh6F3F7wVxGqONIgTxMI+6LQh7Q0wIt7b8dQeEoW
        2pys93PMT2lTmeUUM0quROe1AKQsW30=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-vVGq5zOzPwSk47dFeeyHnA-1; Sat, 03 Apr 2021 06:43:37 -0400
X-MC-Unique: vVGq5zOzPwSk47dFeeyHnA-1
Received: by mail-wr1-f69.google.com with SMTP id o2so373530wrm.9
        for <kvm@vger.kernel.org>; Sat, 03 Apr 2021 03:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=61f7oFHi8TAP6R3U20yKNfdx/rbT6AGQPs/+ynBgVBY=;
        b=jLvrlHY0Br0EOvfUQnDOSv5LutdGYr6W/FJg+/5INf0ZCSZsytnZsilLI7Uee9OnPu
         agXyxChVHOyscqgYV0wF18FGI626PlhVYI2XZX5d/iwMsGJrHWOn8CX5yMfKxLy8NXeq
         mPvnAZvIPWnDmEUV/qNXvqS6AyXrRypFwc0pwv1OB0XpQfPkxJRuYdd+vJlUYwbJeys+
         Vln7J51fMZ0GeXvxVGtdmYajq4WEHauc1/ZoIY7jRfqID34m3nFQbOgGdlrXcRevFcrl
         PNHm8ybGJZwmfrtFedHPjungEmS621VhD4kwyB3C1Yjk6IVX3vOKUNevr4JAYMqxUIQI
         TY+g==
X-Gm-Message-State: AOAM532pLb8E765sLXPexWwxR38INqebKqi8M6AEkPMl1mZC63PIQXdr
        ofJo6geMjYi9+426DyMSnlgXky+0MYADzXkucsV2l1MZ0PmpnYJ5rQ1Ax4BYueeGrxZ2Wd+Hl+F
        2gp7iWxg1aAoY
X-Received: by 2002:a5d:6b86:: with SMTP id n6mr19420844wrx.52.1617446616085;
        Sat, 03 Apr 2021 03:43:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6ZVY9JvAkugXwQNIfRTY/EM8knw5XoWwMss5fVKS+esOCD+LL95JYT9Dol9NEqaEHEp3NDQ==
X-Received: by 2002:a5d:6b86:: with SMTP id n6mr19420831wrx.52.1617446615873;
        Sat, 03 Apr 2021 03:43:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m5sm18762558wrq.15.2021.04.03.03.43.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Apr 2021 03:43:35 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: MIPS: rework flush_shadow_* callbacks into one
 that prepares the flush
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        seanjc@google.com, "open list:MIPS" <linux-mips@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
References: <20210402155807.49976-1-pbonzini@redhat.com>
 <20210402155807.49976-3-pbonzini@redhat.com>
 <CAAhV-H4wskLvGD1hhuS2ZDOBNenCcTd_K8GkYn1GOzwnEvTDXQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aab8a915-6e73-3cba-5392-8f940479a011@redhat.com>
Date:   Sat, 3 Apr 2021 12:43:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4wskLvGD1hhuS2ZDOBNenCcTd_K8GkYn1GOzwnEvTDXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/04/21 04:31, Huacai Chen wrote:
> Hi, Paolo,
> 
> TE mode has been removed in the MIPS tree, can we also remove it in
> KVM tree before this rework?

I tried the merge and it will be enough for Linus to remove 
arch/mips/kvm/trap_emul.c.  So I will leave it as is, but next time I'd 
prefer KVM MIPS changes to go through either my tree or a common topic 
branch.

Paolo

