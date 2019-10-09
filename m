Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BF5D07BE
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 09:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbfJIHCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 03:02:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38342 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725440AbfJIHCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 03:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570604523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=jq9NMJJ6aC6x31llQky9nN2iVQnmzY3MT7LdFGPCTXs=;
        b=FwC2n7j9ybVXlxVfsw8r8sGYXHg64JR5DtdDUG1cyOVLCNcPFU7lBnUbTQSzru7D3XRJJC
        9NVX9GiFUgpJg/kXD2ZdP49tfnoJx/5zqsCf/qWA7PTQW2/IfvaP5bAeKZrgZRjolr/8b7
        aeNXKmCTAQfr4Ni8/J4k9uhU5Yu81Ao=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-6lCnoR_WPQOeP3IiUUAarg-1; Wed, 09 Oct 2019 03:01:59 -0400
Received: by mail-wr1-f72.google.com with SMTP id z1so639825wrw.21
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 00:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WbTf2DyuK7rqiyaYhQzII2F7cDh00yENfhYa1eMTZt8=;
        b=RmyVhsnawA3FCGXufoiop7BZig66zZpd/5WWcRTjTZfGHLlppYHINaWMhTbVv12g2u
         L52BJe7PLFViz/woTV+1CvQdwXInucs8S7Ir17ECVXHOPsiGG0H9IUAYstzTgoRZlYDg
         lrZ/nCRW+hNcMr05GdI+Cn5d9YT0nYbEbGMGpoHmNxXNDIuiXmEigzXE0Ld/I70rh3aC
         JnEDjpigcmdb81iviEplGPNqIyFrNBX4H0i7s7hk9uH2MJLvZcljiiiSl4UHjllUKIcQ
         TJi86L6XoCDu9d9s7GhF6MouK5bk+Ru2QLDjYWQWr3dj4sqemBPHgPldkxlNksD2ypVc
         0YMA==
X-Gm-Message-State: APjAAAX94n7DwLxf9GFVOr11ZqDCm90xXCzoFym18x+Bk9GiYQ+SZ4R2
        e031ueORVEf839ts1hcsevfFXJGhA2Nf5xsDA3iudpzkccc/m/g+vrRdougsoXAAVgRSS3zvcdZ
        EfCsOk0fxX2zt
X-Received: by 2002:a5d:65c1:: with SMTP id e1mr79935wrw.364.1570604518318;
        Wed, 09 Oct 2019 00:01:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw1lqgb50BqZK8E4sTx1gR5italRruZXOR7kppeyZn9eabFv31kK/RI/42KdoVkvqpWHzQ7lg==
X-Received: by 2002:a5d:65c1:: with SMTP id e1mr79913wrw.364.1570604518060;
        Wed, 09 Oct 2019 00:01:58 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id i11sm1186807wrw.57.2019.10.09.00.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 00:01:57 -0700 (PDT)
Subject: Re: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
To:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Luwei Kang <luwei.kang@intel.com>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-3-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <56cf7ca1-d488-fc6e-1c20-b477dd855d84@redhat.com>
Date:   Wed, 9 Oct 2019 09:01:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009004142.225377-3-aaronlewis@google.com>
Content-Language: en-US
X-MC-Unique: 6lCnoR_WPQOeP3IiUUAarg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 02:41, Aaron Lewis wrote:
> -=09=09/*
> -=09=09 * The only supported bit as of Skylake is bit 8, but
> -=09=09 * it is not supported on KVM.
> -=09=09 */
> -=09=09if (data !=3D 0)
> -=09=09=09return 1;

This comment is actually not true anymore; Intel supports PT (bit 8) on
Cascade Lake, so it could be changed to something like

=09/*
=09 * We do support PT (bit 8) if kvm_x86_ops->pt_supported(), but
=09 * guests will have to configure it using WRMSR rather than
=09 * XSAVES.
=09 */

Paolo

