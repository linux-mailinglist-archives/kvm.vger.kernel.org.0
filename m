Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA33B6B001
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 21:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388837AbfGPTjw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 15:39:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34846 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388830AbfGPTjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 15:39:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id y4so22228287wrm.2
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2019 12:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t3P1kK9j5aZnm64L6bQvhvc5NzJl5uI2QwqQvBGZfOE=;
        b=bAF1QcVgFr5fXZwLXVedusFNPrPrqwOaP4YG+nZvqhU6hiq1CklG+4QNH8HR6Ep0Fh
         QhQ80T710C8VH/hXCp1Cw7346D49eRhzujoEHS6E+CcBctuZhJwtTnTtW2mANUMbaeZZ
         fqVPCegbVAodxM+VwoYWIDi1ypRi1eB3RSTvNaUU0UJbI65uEOctpLyM7N1HHZXh7Tnd
         rUUGuDXR6KrbGZPl4gbTp6eMxcuI0lwA3DoRuBiDpGxWUUBaZpF2UIRnX7D2jrcCHXsc
         cC6H/ukfozlO5O/rmuGJ2gudaPD/8ThIKrgvzNCF/Bz9ef0bCgfTXohwOCdQnF5bExmj
         CZzA==
X-Gm-Message-State: APjAAAWjSa9eGrSgaTcPPUXHfj1L25QkPf3DSs4j157KO5mc9XaXfvD/
        guYozJNjcT6QH/mnXLX5O6pBcGJbf/Q=
X-Google-Smtp-Source: APXvYqxitLTvp2penHV7QNbMmYXATIji5Qg0Vq6mRm+U+ta0phWQCMz2LQYoFVTypmA+du7ZV7NdMA==
X-Received: by 2002:a5d:540e:: with SMTP id g14mr39657300wrv.346.1563305989616;
        Tue, 16 Jul 2019 12:39:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b159:8d52:3041:ae0d? ([2001:b07:6468:f312:b159:8d52:3041:ae0d])
        by smtp.gmail.com with ESMTPSA id v4sm17374587wmg.22.2019.07.16.12.39.48
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 12:39:49 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
To:     Liran Alon <liran.alon@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
 <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
 <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
 <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3cdd12c4-c3fa-5157-1a91-69e333750152@redhat.com>
Date:   Tue, 16 Jul 2019 21:39:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/19 21:34, Liran Alon wrote:
>> When this errata is hit, the CPU will be at CPL3. From hardware
>> point-of-view the below sequence happens:
>>
>> 1. CPL3 guest hits reserved bit NPT fault (MMIO access)
> Why CPU needs to be at CPL3?
> The requirement for SMAP should be that this page is user-accessible in guest page-tables.
> Think on a case where guest have CR4.SMAP=1 and CR4.SMEP=0.
> 

If you are not at CPL3, you'd get a SMAP NPF, not a RSVD NPF.

Paolo
