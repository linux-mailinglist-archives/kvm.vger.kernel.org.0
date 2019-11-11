Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F2AF75AC
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfKKNx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:53:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41044 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726811AbfKKNx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:53:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573480437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=KKS7ukaM3s+RcRPMeI0PJo9PV9ZqwXnsUCbsWMC+bQk=;
        b=QvW3YevVXcEw3V5qw3X2iVwo9TWdF5+X3BDlllGOKDxNBtvAlUGECppffjsTBN6bs3iCqq
        WB5XFol3Lu3GRzHEY+Vy+SrDm/95AH76KwOpwbsDCGtr+SbwMcXXkoFpXyTctnhbHuZMUv
        GTi8bu/Xwk1evkucRsla3h+X5Wj3nUY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-jPPONaSHMQG9IQ3fmwBUlw-1; Mon, 11 Nov 2019 08:53:54 -0500
Received: by mail-wm1-f71.google.com with SMTP id v8so3813962wml.4
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 05:53:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jDdR6HL2uqFXDuXRbpzrDYWDx7IlEFg5B/eQCvJy0rs=;
        b=DLcHYwWafRkFgrHcpN5iznUIkbFbhXYkbGeHpqQUVTKJYIiNPJNVZxF4m0gAGzbso3
         jI4nAUw8l8qcCB7ubjJAp57Spjvofhu1sErjVuBCe1QEPglgbGmwrMTi2mS0ApdwLd5C
         CUXaOR7TOjWJjn+v0bszgpvogiU/RlxIn0u2uCByaP+p2bs3g6+mCWBF2NvKVmgOZoqe
         VJhr5/wODe6oOJqf49oEwmLCHT4QjaoY/j3NfjfDd3x90VjkfCQc5pbUGTKx3TS5re7r
         5KvbZ0LmMyoNZKWGtBdicnGyRFl+xuum+qgUWW9FZzL5IoiVZcq2USlcBLajuAF1L+H3
         9P2g==
X-Gm-Message-State: APjAAAUHfHyB3QedJQAvHqW2j3LKi0umkiaDa+d2vvatcv0y26+f4Dn1
        EmnfiNwxFW3rCNxjOhcaa0cpxyCeESFc9z2mRRnJ4S6M2ZIRbDhQYmmvgjSd9ACyKKPfQxe7C+0
        Nk14xrZdDPM2a
X-Received: by 2002:a1c:6885:: with SMTP id d127mr19691540wmc.64.1573480433140;
        Mon, 11 Nov 2019 05:53:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqyYGt7GZv5AYsab37ICD/qgIO6Wvt8jY5Hx81rPIZy+F4FRugWtB5EDFqrYsNHkWTw3dI7V1Q==
X-Received: by 2002:a1c:6885:: with SMTP id d127mr19691522wmc.64.1573480432847;
        Mon, 11 Nov 2019 05:53:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id h124sm21529100wmf.30.2019.11.11.05.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:53:52 -0800 (PST)
Subject: Re: [PATCH 3/5] KVM: ensure pool time is longer than block_ns
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-4-git-send-email-zhenzhong.duan@oracle.com>
 <20191101211623.GB20061@amt.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <76044f07-0b76-cd91-dc87-82ed3fca061e@redhat.com>
Date:   Mon, 11 Nov 2019 14:53:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191101211623.GB20061@amt.cnet>
Content-Language: en-US
X-MC-Unique: jPPONaSHMQG9IQ3fmwBUlw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/11/19 22:16, Marcelo Tosatti wrote:
>  =09=09if (!vcpu_valid_wakeup(vcpu)) {
>  =09=09=09shrink_halt_poll_ns(vcpu);
>  =09=09} else if (halt_poll_ns) {
> -=09=09=09if (block_ns <=3D vcpu->halt_poll_ns)
> +=09=09=09if (block_ns < vcpu->halt_poll_ns)
>  =09=09=09=09;
>  =09=09=09/* we had a short halt and our poll time is too small */
>  =09=09=09else if (block_ns < halt_poll_ns)

What about making this "if (!waited)"?  The result would be very readable:

                        if (!waited)
                                ;
                        /* we had a long block, shrink polling */
                        else if (block_ns > halt_poll_ns && vcpu->halt_poll=
_ns)
                                shrink_halt_poll_ns(vcpu);
                        /* we had a short halt and our poll time is too sma=
ll */
                        else if (block_ns < halt_poll_ns && vcpu->halt_poll=
_ns < halt_poll_ns)
                                grow_halt_poll_ns(vcpu);

Paolo

