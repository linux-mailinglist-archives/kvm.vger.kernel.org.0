Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4B01A32FC
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 13:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDILOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 07:14:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34122 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725972AbgDILOV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 07:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586430861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eVe7IfDc6Eg1zSotYzISNC1XY4K3ye5o8p4mKeTvCRU=;
        b=AuqI9N3BBoS1NgKa6tShcc4zCDYCUbFqZwliqBDcdTNC+fE4V6+NtI+KUpNlMtiYQKRtRr
        AplFdj07kkIsFt8wZLT4kUPCHaPd2sAS2epVwvrwM9TbDChQxB6If3/pyAUTqCVuISfoCQ
        89diyoLRHe4mAQCzCRY1dR5kzL7we4w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-tPY8mMGaO1C4kcWqZxbH0g-1; Thu, 09 Apr 2020 07:14:17 -0400
X-MC-Unique: tPY8mMGaO1C4kcWqZxbH0g-1
Received: by mail-wr1-f72.google.com with SMTP id j12so6145459wrr.18
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 04:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eVe7IfDc6Eg1zSotYzISNC1XY4K3ye5o8p4mKeTvCRU=;
        b=XlplFhw5CWvDrheQcDT8XcnO/e75PkORqco6gFXhKjMBjvZMyGyeHr79HKX0/yShTt
         eG8WQs4azBrcSZq5D4niubXHTwhw974sAow2/USVvJ3Ke2sHQ4MHeQksyc9aAhxF4kkT
         qqEhifsY4wE/9dlNQpzjbKd0SeNxdV6Jv2xECZskZp3BtsWhsOITKiuz5/a+tRI7TiMv
         Y2xGCNpwfjedD9xTcTkCqyhrB9xowSkQFUiIstMvN9fFm+81ov4poh2rbbbBfEkTADzE
         U6xTh4OStmyFYpYOelriQMqTimIXooAbOWKoifU9f5xDKWw3nGM9vJHvBVASc3oSAJTm
         eq3A==
X-Gm-Message-State: AGi0PubopfyuzQROcugpvVWU8Ib0H3RTovbKv+WhjLnKIVoDg6usjt0j
        z1alQFh/kf3S8vp1bKfcALj2Dywx5vpLiiHC2yj+7Eyt8mq1dGejZYvHdRk/zhUAF4JMU271l0b
        ZtQ2ngIpPX34P
X-Received: by 2002:adf:aad7:: with SMTP id i23mr13446979wrc.184.1586430856639;
        Thu, 09 Apr 2020 04:14:16 -0700 (PDT)
X-Google-Smtp-Source: APiQypJrJJvOfBtCg0nF+bFCAwjKhMQCswXXApj7bVfJMGmrNUaRyCwySn1n7/vsqTWSUHcBZMCe9Q==
X-Received: by 2002:adf:aad7:: with SMTP id i23mr13446952wrc.184.1586430856377;
        Thu, 09 Apr 2020 04:14:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c20sm3387575wmd.36.2020.04.09.04.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 04:14:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Baoquan He <bhe@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        dzickus@redhat.com, dyoung@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 0/3] KVM: VMX: Fix for kexec VMCLEAR and VMXON cleanup
In-Reply-To: <20200409012002.GT2402@MiWiFi-R3L-srv>
References: <20200321193751.24985-1-sean.j.christopherson@intel.com> <20200407110115.GA14381@MiWiFi-R3L-srv> <87r1wzlcwn.fsf@vitty.brq.redhat.com> <20200408151808.GS2402@MiWiFi-R3L-srv> <87mu7l2256.fsf@vitty.brq.redhat.com> <20200409012002.GT2402@MiWiFi-R3L-srv>
Date:   Thu, 09 Apr 2020 13:14:14 +0200
Message-ID: <87imi829o9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Baoquan He <bhe@redhat.com> writes:

>
> While I would suggest adding kexec@lists.infradead.org when code changes
> are related to kexec/kdump since we usually watch this mailing list.
> LKML contains too many mails, we may miss this kind of change, have to
> debug and test again.
>

Definitely makes sense and I'll try my best to remember doing this
myself next time but the problem is that scripts/checkpatch.pl is not
smart enough, kexec related bits are scattered all over kernel and
drivers so I'm afraid you're missing a lot in kexec@ :-(

-- 
Vitaly

