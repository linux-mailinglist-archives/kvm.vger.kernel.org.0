Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E358804B9
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 08:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfHCGla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 02:41:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33842 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfHCGla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Aug 2019 02:41:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so79342639wrm.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 23:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bCAARCxw6zb522vIF1/F1TsSvMa3dI/ciDgyTzIdOx4=;
        b=TgP4SCZheY8YOr1CPID9m4bsqtdVdPLdHkSGisTqWlEBRjFz4zbc+kC7gMR9SSULQg
         OU3x/Cq2NQBqrYFgJipSMhxViqEymgULM2j2JE/OYi7JIQLx5bL9bXKZEna9mzgPFSEe
         1UemvXXr6ab1FGFzazOv4E6WqPkONhoO6MnRmRbuB3EDx8NnkwzP0Rs3QZs35UDMxZl0
         GXMw+JVmQo+iMS6unw11WbYEp38pFdut/FzgRzL9+Er4roCm0R2YzGqy4yqZmbZ+MilL
         Rmbc2thsGB3tEHQRVhfy7xJDiOh9uEynr8xS4wAM7MtgBtVEdASilMXLP9QyCc1jDhWC
         fy7w==
X-Gm-Message-State: APjAAAU4LqpRMR62oOIwGxW0luq8fKudw0iRoe8miM5yGTDYXHDPrNVM
        YGQnzF/bq/nJ/uTovOieXPmsDQ==
X-Google-Smtp-Source: APXvYqy7OSGxNl0+EgJQYDBAzWv2iXpLXjLUXVT0UHiSR68dXLvHmgd68cVQXfzTdbdnNdl7ggLLLQ==
X-Received: by 2002:adf:ed4a:: with SMTP id u10mr66202962wro.284.1564814487966;
        Fri, 02 Aug 2019 23:41:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id 17sm64589032wmx.47.2019.08.02.23.41.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 23:41:27 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] KVM: Fix leak vCPU's VMCS value into other pCPU
To:     Wanpeng Li <kernellwp@gmail.com>, Sasha Levin <sashal@kernel.org>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
References: <1564630214-28442-1-git-send-email-wanpengli@tencent.com>
 <20190801133133.955E4216C8@mail.kernel.org>
 <CANRm+Cy1wWSwn7HH-dNWeR6FX1TT_M7t_9vvRMdCKFATmvFDkA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c96d6707-87bd-1794-331e-6fa1a2d562f8@redhat.com>
Date:   Sat, 3 Aug 2019 08:41:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cy1wWSwn7HH-dNWeR6FX1TT_M7t_9vvRMdCKFATmvFDkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 02:46, Wanpeng Li wrote:
> Thanks for reporting this, after more grep, it seems that just x86 and
> s390 enable async_pf in their Makefile. So I can move 'if
> (!list_empty_careful(&vcpu->async_pf.done))' checking to
> kvm_arch_dy_runnable()

No, wrap it with #ifdef CONFIG_KVM_ASYNC_PF instead.  Thanks!

Paolo
