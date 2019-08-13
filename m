Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D74C8B2BD
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 10:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfHMIoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 04:44:00 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40340 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbfHMIn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 04:43:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so7880462wrl.7
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 01:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QrW7dS2ds3pbrdiGP+Xfw3R+Xx+cVjaMWqFORv9YS00=;
        b=LMIuqmDM3G//PemWtwwoYWRdnhYO4JTAfNyenkJQZYP8hbQmkc2Pal4YtMZqo/z0VN
         zqQH4Dz6c8ctn9a9bNzisOpFtY83hgx6e6wNJG9niGIPe8Y25q/ZHogXqy5NnXW5Ot4I
         BuZfxyGxTX42b3XzhCHhqs45ywqBo833tuHpaS4WFuyjAKq3//2osSXTGG8jU6NSbNjx
         VEpS7zPAQnr06ez26J8v4lYZezdTg5QcGWo4oTtGAVMS7Ybs8uSG6S2xAcIa68bODKz+
         o2+hcEMAFCQVV8DhxvmV0dg5R6QaK9tZl4SwjWS80apUmWnTc6PyzEnlsstMV0MRZFgf
         FFRA==
X-Gm-Message-State: APjAAAXf7IppH3oP0b4/aM6ENpkX1Kj2tirz+wepnzvoVuIPRTk4UBhB
        /Nmketrou83x8TNVcYOd6aEJKQ==
X-Google-Smtp-Source: APXvYqxuWhc1YpCqxMrLLcWkuQ8VY9K/YArqTGXAb48mAXYstqGvOVyemZekybg0GEAvyY/bBnxajA==
X-Received: by 2002:a5d:4e06:: with SMTP id p6mr21211891wrt.336.1565685837546;
        Tue, 13 Aug 2019 01:43:57 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id g14sm16821663wrb.38.2019.08.13.01.43.53
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 01:43:56 -0700 (PDT)
Subject: Re: [RFC PATCH v6 13/92] kvm: introspection: make the vCPU wait even
 when its jobs list is empty
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-14-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c82b509a-86a7-6c2c-943e-f78a02e6efb1@redhat.com>
Date:   Tue, 13 Aug 2019 10:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-14-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 17:59, Adalbert Lazăr wrote:
> +void kvmi_handle_requests(struct kvm_vcpu *vcpu)
> +{
> +	struct kvmi *ikvm;
> +
> +	ikvm = kvmi_get(vcpu->kvm);
> +	if (!ikvm)
> +		return;
> +
> +	for (;;) {
> +		int err = kvmi_run_jobs_and_wait(vcpu);
> +
> +		if (err)
> +			break;
> +	}
> +
> +	kvmi_put(vcpu->kvm);
> +}
> +

Using kvmi_run_jobs_and_wait from two places (here and kvmi_send_event)
is very confusing.  Does kvmi_handle_requests need to do this, or can it
just use kvmi_run_jobs?

Paolo
