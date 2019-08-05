Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72AA818AA
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 14:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfHEMBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 08:01:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40167 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbfHEMBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 08:01:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so84098987wrl.7
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 05:01:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2nagADd5jn/PM+jdv3CsfqiPWcm300QiQQSn7jI3dpY=;
        b=IofuysfqH0qA9GUIwjxXWjiQXQ7WkDCklfwtKGb1l0eVXEXKhndme9k6HU7FDc8nRN
         1cV5oZHfrW3+Mhhxu1N6Mhdp3aJlKyyHgVvfnkNhlflkkaeoiA09gYVtnXqM/dw+SA4F
         UoqrsiK02jpT8/5i6gYPl6J4xNxMvUVGBoBS+bcidTcwnFywsSY9WYl2y7iI0l2KhDOC
         fS2JDZ7108V68+cG0qdMUAinhd+CJAgd89s9IdcFxOwz9Odz8VoQ090EydEjZ7JxykKV
         WMrOv6FMAtvYmb79oApvgKRPMuKIrm6Uu2SW+dZUnjS3Il9VJ9fWbxppOqq5nt8IwgmL
         YAUQ==
X-Gm-Message-State: APjAAAXEbV7UhzADscGb20XaHimHGBDrGLyTpJLMEcLiXkDalXDlvqDX
        NADV8WNyalzxOMulm+XgOR2nAbOrQhc=
X-Google-Smtp-Source: APXvYqxE67uGRsevI1zEKu6WcCvy7LGAqb+5YSaaPfzVS62blyzVnMo0SSHLm4YD1CuRcd1v857erg==
X-Received: by 2002:a5d:6508:: with SMTP id x8mr42706085wru.310.1565006509205;
        Mon, 05 Aug 2019 05:01:49 -0700 (PDT)
Received: from [192.168.178.40] ([151.21.165.91])
        by smtp.gmail.com with ESMTPSA id c1sm192489759wrh.1.2019.08.05.05.01.47
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 05:01:48 -0700 (PDT)
Subject: Re: [RFC PATCH v2 07/19] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
To:     Anup Patel <anup@brainfault.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
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
References: <20190802074620.115029-1-anup.patel@wdc.com>
 <20190802074620.115029-8-anup.patel@wdc.com>
 <edbed85f-f7ad-a240-1bef-75729b527a69@de.ibm.com>
 <CAAhSdy2PDSpTy1JEEC2LCB4ESvZHBbkVEZ2wqz-D2b7SKD5VSg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <09417197-36e8-718f-f106-29466ef406e3@redhat.com>
Date:   Mon, 5 Aug 2019 14:01:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy2PDSpTy1JEEC2LCB4ESvZHBbkVEZ2wqz-D2b7SKD5VSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/19 13:56, Anup Patel wrote:
> We will certainly explore sync_regs interface. Reducing exits to user-space
> will definitely help.

sync_regs does not reduce exits to userspace, it reduces ioctls from
userspace but there is a real benefit only if userspace actually makes
many syscalls for each vmexit.

Paolo
