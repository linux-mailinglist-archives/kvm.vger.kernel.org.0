Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD197A7D0
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 14:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfG3MK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 08:10:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54270 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfG3MK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 08:10:58 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so56938741wmj.3
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 05:10:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9L0zBGqIjlWL1IQrDXZZd5jCWfrUHuNyOkNCDrFw/Cs=;
        b=tSok8UIOPkAfKaNjn099xbWL5Todm04CMf66CDQuFZL9WTcPNTnnVzSMsMbvBGt68Z
         1fvPx4IzXL9UOYdlUH8PQ9puFp5V2+DuJfy+0M9+ZAsO/82QBL5s4exPmLKjmahxdS5d
         Eu7R63j/O7hL+gVN0PrHyQNwB9WdRwEmcy7vX4I66xwYr5f6GXYFsMo37lhTowcrgYAD
         7/jSBciZfPJroxrJFNY6EDngpcUlr8WqAScvYjr1jNMEGAOhopT4XqRTmgOb2mOHlQbq
         /G81G6BgsvDWGMngpIHhpknwnFHvvBEc+Mdjl6WRduyiVMH5b7CASnZX0BLNK2Cmu5Br
         Z3ZQ==
X-Gm-Message-State: APjAAAUL/FuPO+B5cVx+/fe5TXkSpE+s/Cs4Tf05DELasGQFLc+8HLXI
        3jIi49lpdmDWcUop0DKBSIWYBQ==
X-Google-Smtp-Source: APXvYqzRKfHoZNVIgIXgBiYl7T8xPjJrXf2ElRHPMC0DZvjUOPtbRAo+bHcxkpSIp0MMlJYsQjsIbQ==
X-Received: by 2002:a7b:c4d2:: with SMTP id g18mr105796251wmk.79.1564488656203;
        Tue, 30 Jul 2019 05:10:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id t15sm56691815wrx.84.2019.07.30.05.10.55
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:10:55 -0700 (PDT)
Subject: Re: [RFC PATCH 06/16] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
To:     Anup Patel <anup@brainfault.org>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-7-anup.patel@wdc.com>
 <3caa5b31-f5ed-98cd-2bdf-88d8cb837919@redhat.com>
 <536673cd-3b84-4e56-6042-de73a536653f@redhat.com>
 <CAAhSdy2jo6N4c9-_-hj=81mXjHjP8mvZy_8jOdRZELCyU9Y8Aw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9f84c328-c5ad-b3cc-df0f-05f113476341@redhat.com>
Date:   Tue, 30 Jul 2019 14:10:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy2jo6N4c9-_-hj=81mXjHjP8mvZy_8jOdRZELCyU9Y8Aw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 14:08, Anup Patel wrote:
>> Still, I would prefer all the VS CSRs to be accessible via the get/set
>> reg ioctls.
> We had implemented VS CSRs access to user-space but then we
> removed it to keep this series simple and easy to review. We thought
> of adding it later when we deal with Guest/VM migration.
> 
> Do you want it to be added as part of this series ?

Yes, please.  It's not enough code to deserve a separate patch, and it
is useful for debugging.

Paolo
