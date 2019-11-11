Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE3BF783D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 16:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfKKP7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 10:59:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27770 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726845AbfKKP7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 10:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573487979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=21rYRK1WikbExV5oVruw+sgbHAkBfvXAQMuMqjWgAl8=;
        b=jU0e2WYFiXBqrZum497Z3KACbIU2iLUH7wge5oyUelZlZnjG69WiPutNaa8AZiYUgWDjpZ
        Im4IKIWAdZ26KhbCkvVAz/+3YIkkFYwwOVCXktq5dZnju2F2W5PAR58YPsCDBXbAQ+kxAH
        57NZemNeiHGQaxPXQlzYSLkUxwljJ34=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-WHTdh2ZrPver_fMuMEojyg-1; Mon, 11 Nov 2019 10:59:36 -0500
Received: by mail-wm1-f70.google.com with SMTP id f191so8598160wme.1
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 07:59:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xE0euolwXuo2nxO5BDJoVVnzsqQOi/h+lidN1W4OF1g=;
        b=hnCr0ihDHYqmZ1iG1J2GR2lhHindmRW/j6PhLQ2GGLkBoivsUjO8x7jzEVDtS99boG
         6iRq2QUofGqS3KtvidlGQa10VtMc2DNsP4xbk476yp+pK/5RLheGMTeuCc7qXxDLUh/f
         9UFIhym3nLksgSsqA4edH8U1TgDMwdUzEeKt/a7CfjMGT5y2Ij8lpBmJYPtYWQ5WBNmO
         a/9vQoNl1J1kccGwsB9Jkdn4SWTuUicm0pF5al+MKZGbi5ODIRonkfT5ak6WUMVPOZEo
         nnEBC5JPqDEdmo2MXbKdvM3MlEWjIFXS0gl7pGI4U3x0p5elKTg4gyCJWPdcuXnP7xc+
         ngYw==
X-Gm-Message-State: APjAAAUnCCuUlSY18GJncvTO1YUc/KwwnVoja+8wGkQGyyKCVh+yVT4I
        8sn/Xjip19m+QzIKICkvK2H55hbPq3yOKmgmCIPlCVlGqiAgizEdd+SyK4HAf1hapcY4J6oMpXr
        8LQLiAjrSOj++
X-Received: by 2002:adf:f445:: with SMTP id f5mr10163642wrp.193.1573487975383;
        Mon, 11 Nov 2019 07:59:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqymVEK/xUGaMUciWwTfHY2hjKfJP8CoPSLKDLmdhIlUX8j7E7jjbJbgUDJP7wN27YHTq5IMTA==
X-Received: by 2002:adf:f445:: with SMTP id f5mr10163629wrp.193.1573487975118;
        Mon, 11 Nov 2019 07:59:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id z9sm7440847wrv.35.2019.11.11.07.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 07:59:34 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: nVMX: Update vmcs01 TPR_THRESHOLD if L2 changed
 L1 TPR
To:     Liran Alon <liran.alon@oracle.com>
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
 <20191111123055.93270-3-liran.alon@oracle.com>
 <a26a9a8c-df8d-c49a-3943-35424897b6b3@redhat.com>
 <6CAEE592-02B0-4E25-B2D2-20E5B55A5D19@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <58163b3f-d4ac-6091-a0f8-7e987c224118@redhat.com>
Date:   Mon, 11 Nov 2019 16:59:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6CAEE592-02B0-4E25-B2D2-20E5B55A5D19@oracle.com>
Content-Language: en-US
X-MC-Unique: WHTdh2ZrPver_fMuMEojyg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 16:24, Liran Alon wrote:
> Because when L1 don=E2=80=99t use TPR-Shadow, L0 configures vmcs02 withou=
t TPR-Shadow.
> Thus, writing to vmcs02->tpr_threshold doesn=E2=80=99t have any effect.

Uh, sorry that was obvious:

 =09if (exec_control & CPU_BASED_TPR_SHADOW)
 =09=09vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);

Paolo

> If l1 do use TPR-Shadow, then VMX=E2=80=99s update_cr8_intercept() doesn=
=E2=80=99t write to vmcs at all,
> because it means L1 defines a vTPR for L2 and thus doesn=E2=80=99t provid=
e it direct access to L1 TPR.

