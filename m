Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18B46B041
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 22:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfGPUNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 16:13:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37573 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728535AbfGPUNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 16:13:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so22301532wrr.4
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2019 13:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fdtaa5Mk+vn+zBbJ4ERXB6fzzU4M4WV7ztEIjLq36Mc=;
        b=sGYzfo0rQVFBwNpvR3OdH7/OoRM0K2159C+5qkCGDDgKjF94Wu5DxUd9/ZxVblRrBp
         oXfLUcaIJ3YG9PE+z8YqDgzi58cVSgNidcC7MxQULjMqnm21u68vXWSrFwBGS8yAYy8D
         fkIf1JuLM8yXV7sNeQ8Rhcn7qTysOpBq0JikK9ZSm/aa34sAkDV4VqF621uo6g8Iivnp
         w1G3q4Re4LoSSZehhVRoZcAY4klL12de25FIDIihZ1IFVWim4Dvy0DT7zT/A/RegwPtf
         MXRu9qZyGirK5QoO/iOeDQ25qrj4ZQrJZbifkb/pWukj3ynFFAPpDHDP/81SAn8WXNIG
         vLnA==
X-Gm-Message-State: APjAAAV8blO5JrQgEowMKJd+6y1oL1huvluyejGQ0b3GhIXu2ZLAk4hb
        LjPiAGcKg1CT+sr3f/KOGh44OQ==
X-Google-Smtp-Source: APXvYqx+Ge7F0Er38BlXtV7V8UVjxIF3JQzeQ10j2+WKx4MIkkn44KC5rsvaDP4+nSV0PWDNSenXcw==
X-Received: by 2002:adf:df90:: with SMTP id z16mr7602770wrl.331.1563307983455;
        Tue, 16 Jul 2019 13:13:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b159:8d52:3041:ae0d? ([2001:b07:6468:f312:b159:8d52:3041:ae0d])
        by smtp.gmail.com with ESMTPSA id 18sm21224557wmg.43.2019.07.16.13.13.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 13:13:02 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
 <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
 <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
 <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
 <31926848-2cf3-caca-335d-5f3e32a25cd3@amd.com>
 <20190716200749.GC28096@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <aa2d39dd-8535-2a30-e35c-5243e8d08d80@redhat.com>
Date:   Tue, 16 Jul 2019 22:13:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190716200749.GC28096@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/19 22:07, Sean Christopherson wrote:
>> We are discussing reserved NPF so we need to be at CPL3.
> For my own education, why does reserved NPF require CPL3?  I.e. what
> happens if a reserved bit is encountered at CPL<3 (or do they simply not
> exist)?

Better: what happens if a reserved bit is encountered at CPL<3 *with
CR4.SMEP=0*?

Paolo
