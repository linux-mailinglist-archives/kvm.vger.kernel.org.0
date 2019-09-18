Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A724B6595
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 16:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfIROLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 10:11:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48936 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730334AbfIROLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 10:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568815898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=eYfolJm2ctgBFFzn1+Uof+Aznt2DY6/Wj6EoPA4iY/8=;
        b=VNIxg56/J01TI5FBfLcMlLZEgmJ76faD0zu7xfSlGAXTJ0xwCfi/9cxfqwm0jxlvWvzTtx
        NLMVNuMjFpqSXaA94y4abF9tB9hIcSa5+xbgdHeSZX+bvrbjvxsO4iMdmyVqpwFRciGhEa
        cndN8vWSm/jFZ3DUz6JwqsBlFXEdzU8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-Jchx3TCYOxa9inRLGTe8lA-1; Wed, 18 Sep 2019 10:11:37 -0400
Received: by mail-wm1-f69.google.com with SMTP id s25so80569wmh.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 07:11:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gU04MhQdP4BkI/L+RLwBCZzg4I06FO6JtiKrPkqToDk=;
        b=L7pSOKu22+NW+05GFLWR3PvEQTLHLnDAg2NsSI5pFnIf7hak4lQlJDHqPrPzg96Y1z
         +yD4UACE0VOLgaGSJ3ztdgdD5DCHA3m65StPHtQf7r2r6VOQFS9zi2nCIlcakmyGn16C
         fpY0WZFNqAgOPBpzrCS18YDqz8z8iV4hFeVj/0gzaYK+dL0pSI33CQPqzgQLNt3es5CG
         hpDKHADUtX3y4ViyHdJ4X/BXH+8GmR4cGvVoG4OLavOWhfKCQNuiuNvsvV6KpN3+BGs2
         ZMj8CtShgzqwS4iTTR2gshMIh3ZXoGM0jFHwSv7Uhqof6wE6+IUMgtoC2WtDddVeZCbi
         dk+Q==
X-Gm-Message-State: APjAAAWekCZrIPEfSX0QNnLPM1NfKCY+gV2DGV544eJbs//rNMkvdiqq
        kT0I0UdSRwHiJGk/emgipsiC/yTx5HU58p0DwRVJazOP5aVJzRs2jaQVtVwDCjGMpWk1T5hEFDT
        v0zHw6uZ/KE2w
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr2919687wmj.110.1568815895842;
        Wed, 18 Sep 2019 07:11:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwQ7SmyPYoi9WAyE6yYB72cOtIdytEHLz51MBDl9qoydpi05HPbf1c9N+yvJBiOtjRJNGI5XQ==
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr2919664wmj.110.1568815895603;
        Wed, 18 Sep 2019 07:11:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id q25sm2592045wmq.27.2019.09.18.07.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 07:11:35 -0700 (PDT)
Subject: Re: [PATCH] kvm: Ensure writes to the coalesced MMIO ring are within
 bounds
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, kernellwp@gmail.com,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "# 5 . 2 . y" <stable@kernel.org>
References: <20190918131545.6405-1-will@kernel.org>
 <9d993b71-4f2d-4d6e-39c9-f2ef849f5e5f@redhat.com>
 <20190918135932.aitmvncwujmjnwyr@willie-the-truck>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <281758dd-e400-f99c-b2e2-d32bca9f371e@redhat.com>
Date:   Wed, 18 Sep 2019 16:11:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918135932.aitmvncwujmjnwyr@willie-the-truck>
Content-Language: en-US
X-MC-Unique: Jchx3TCYOxa9inRLGTe8lA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/19 15:59, Will Deacon wrote:
> Okey doke, as long as it gets fixed! My minor concerns with the error-che=
cking
> variant are:
>=20
>   * Whether or not you need a READ_ONCE to prevent the compiler potential=
ly
>     reloading 'ring->last' after validation

Yes, it certainly needs READ_ONCE.  I had already added it locally, indeed.

>   * Whether or not this could be part of a spectre-v1 gadget

I think not, the spectrev1 gadget require a load that is indexed from
the contents of ring->coalesced_mmio[insert], but there's none.

Paolo

> so, given that I don't think the malicious host deserves an error code if=
 it
> starts writing the 'last' index, I went with the "obviously safe" version=
.
> But up to you.
>=20
> Will
>=20

