Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC7A56A0D
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 15:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfFZNKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 09:10:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37165 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZNKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 09:10:38 -0400
Received: by mail-wr1-f65.google.com with SMTP id v14so2686336wrr.4
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 06:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bqOWDaCNsHrE1herZzAPunVmKg4cRAUoaCX+z3T2sAM=;
        b=DUy4QObSVxdhD8sAwnGYd+cmzJb7jM4Uqp74eCKdshNq7kV5Bof+RKfXTH8cZsv1br
         KVp6olXWFFXHT0FoVfMBLuksbr7IA7QLpeSfq08OoVERj8nq6mlu324qk2UC5geX+J/o
         KM5UHesEKphBKVLYNYfvbUDy7IwPggwjVRvss9APlQk6YfRWdQ1rZnbtupNR98HVrV8Q
         0eDczyuKugspkbFGmm1+3OtiUfgsMsCU29Jf9vNKCuF2M83iKzekFTSRN42lA++9OxbM
         c6nDmFTVweWT2LSp0flQwSq2MPCkZUKEuhpxJnrysjw8QpVqSBHXe/QmLEx+Q433t8pi
         wV8A==
X-Gm-Message-State: APjAAAW+4Yqia8N+UH9i2Exdjwtlr1PlaL6ALHFaxqqwKs52YBPCMyyM
        k3uw4rceJxrmbtLrdHmtJ+JUMQ==
X-Google-Smtp-Source: APXvYqy/cMPC8Av1yrbGtbve00ZFb/ieRgkL6SpMCmxq4C9XvGvgJpuLHhPLGFVuptpZ/fVy4FDH8w==
X-Received: by 2002:adf:fa4c:: with SMTP id y12mr3606968wrr.282.1561554637009;
        Wed, 26 Jun 2019 06:10:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e88d:856c:e081:f67d? ([2001:b07:6468:f312:e88d:856c:e081:f67d])
        by smtp.gmail.com with ESMTPSA id d7sm4766497wrx.37.2019.06.26.06.10.35
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 06:10:36 -0700 (PDT)
Subject: Re: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even if
 host does not
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        mingo@redhat.com, Borislav Petkov <bp@alien8.de>,
        rkrcmar@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        stable <stable@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Jon Masters <jcm@redhat.com>
References: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com>
 <1c9d4047-e54c-8d4b-13b1-020864f2f5bf@redhat.com>
 <alpine.DEB.2.21.1906251750140.32342@nanos.tec.linutronix.de>
 <56fa2729-52a7-3994-5f7c-bc308da7d710@oracle.com>
 <alpine.DEB.2.21.1906252019460.32342@nanos.tec.linutronix.de>
 <b6c2ac14-d647-0fa2-f19d-88944c63c37a@redhat.com>
 <alpine.DEB.2.21.1906261440570.32342@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f258b10f-dae3-7cf4-5a0c-47fe067065b4@redhat.com>
Date:   Wed, 26 Jun 2019 15:10:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1906261440570.32342@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/06/19 14:41, Thomas Gleixner wrote:
>> I think it's better to leave the guest in control of SSBD even if it's
>> globally disabled.  The harm cannot escape the guest and in particular
>> it cannot escape to the sibling hyperthread.
>
> SSB allows guest to guest attacks IIRC

SSB requires something like

   p = &foo;
   ...
   p = &bar;
   q = *p;

where "p = &foo;" is executed from one privilege domain and the others
are executed by another process or privilege domain.  Unless two guests
share memory, it is not possible to use it for guest-to-guest attacks.

Paolo
