Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF50E6F426
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 18:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfGUQm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 12:42:29 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34877 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfGUQm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 12:42:29 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so33094903wmg.0
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2019 09:42:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OFd9p5Z1lrqVfJPKhxCEmyaKfGu9/VKzqNXTrlw4kyA=;
        b=c/rMv44SyLQ26hwwj8WE/lgqv9ZpmYPoqunBo0+pp50CG/gm3Z6PIDMqa8KNorAUYT
         ek0LoIvv93pHDAJHThnhMSN/xBoME1YbZNohk9cHJId8C0LZBg3XzYi8ulfWnrr+bG3H
         G3pOowcWe1BDHTiBR9q2sP9BMbERPkwvI3FEGgDQmxRBLqMImxiyiO3mxQzTpMmPvrau
         Q4bIZEr4nI2qSjg06Y1RYZTTaJCa4qGw65uRo9X0NV7jOkwBBObyJ+boee0PWkMK2WGx
         ETVleyaCpSpOWEH1MDeBii8Y7EUQS9ZzKmWM3YFaVZerqk5LB/Sjx1sT3ccy1kuTwIFJ
         xi3g==
X-Gm-Message-State: APjAAAXaD48qR3iuVPAr5nXUdefZz1BuSOZgbA9dvH2e69LnKumCQy0l
        rWjIevknipZvaJ/kVy9FW7TtLZtSDmQ=
X-Google-Smtp-Source: APXvYqxOuLOkcbxVIjcnLmPLQWGt+Zii5jmT0NbCLdOvDIXSxUnmIV2Ib8Y0eWz0E6sMj/jPhyLV9Q==
X-Received: by 2002:a1c:a481:: with SMTP id n123mr55632234wme.123.1563727346935;
        Sun, 21 Jul 2019 09:42:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8501:6b03:f18c:74f8? ([2001:b07:6468:f312:8501:6b03:f18c:74f8])
        by smtp.gmail.com with ESMTPSA id 17sm34230310wmx.47.2019.07.21.09.42.25
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 09:42:26 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when
 leaving nested
To:     Liran Alon <liran.alon@oracle.com>, Jan Kiszka <jan.kiszka@web.de>
Cc:     kvm <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <ee67b5c3-d660-179a-07fa-2bebdc940d4f@web.de>
 <A65A74C6-0F2D-4751-97CA-43CFC3A3CA63@oracle.com>
 <c464c26b-30d5-b897-4128-8df65a3f80ff@web.de>
 <76FC3DE7-144C-49F6-8814-6AF7935C8969@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3094dcde-6e9e-f761-8632-688276e1c6ea@redhat.com>
Date:   Sun, 21 Jul 2019 18:42:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <76FC3DE7-144C-49F6-8814-6AF7935C8969@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/19 16:03, Liran Alon wrote:
> How would having a BUG_ON(!cached_vmcs12) on get_vmcs12() will cause false positive?
> I don’t see any legit case it is called and return NULL.

For example, vmx_read_l1_tsc_offset and vmx_write_l1_tsc_offset call it
unconditionally, but then only use it if is_guest_mode(vcpu).

Paolo
