Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B89D6AD9E
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 19:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387984AbfGPR10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 13:27:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46716 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbfGPR1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 13:27:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so21802554wru.13
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2019 10:27:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UI6CwPPGlBo0T18ypxGfNt4/hU+PDlcyIKxsEJztk54=;
        b=HKIEXlOYrMfR5VcxGLl5tchxivWE7Ul9gb4xLbHOZgIwj4VCTfWOxNbMul1eiyBeVY
         5DDe84iHwwt2Vr/mccaIWxMvQIZgPtImKUCUJoBYWoiNfx20135ZLP0isrJBrDj1dUz5
         kmP3VzQT3QGJGBELYxKfsXoah60kUFrRGQNXPhmc7Qo+/f9jXes0o3fCArDmqosVFSfN
         GV0SFTqwDXNtjL3qB/4KX+Sy58KQB1qm6PJf4nEdNr+8PCbnQ1j5Yg+XmZYNEQ9xqeuX
         D/cEbKDcnoIWVbpLdz8LzTwkm7uocOsXjcphWc3Cd/BJOM/2WZwX1l8yYdCFg9CfUJzs
         xWZg==
X-Gm-Message-State: APjAAAUPmuQhrauDqC0Pt93EzBcYi4Ndo8mwDAUuOp0Uju0B1+UWrGP/
        BZnpoeYbh1Yl0KM5nTK2/zFR/MlBCNI=
X-Google-Smtp-Source: APXvYqw49iiJyLgq8NH5m2WfgtKuMJW0FyHjCNV03LpxrPgbD1usNEHsXz+fqBfCw1gGu+7PKUm9Yw==
X-Received: by 2002:a5d:668e:: with SMTP id l14mr36191550wru.156.1563298043503;
        Tue, 16 Jul 2019 10:27:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bca4:e0e3:13b4:ec4? ([2001:b07:6468:f312:bca4:e0e3:13b4:ec4])
        by smtp.gmail.com with ESMTPSA id o20sm49179178wrh.8.2019.07.16.10.27.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 10:27:23 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
To:     Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Singh, Brijesh" <brijesh.singh@amd.com>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
Date:   Tue, 16 Jul 2019 19:27:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/19 18:56, Liran Alon wrote:
> If the CPU performs the VMExit transition of state before doing the data read for DecodeAssist,
> then I agree that CPL will be 0 on data-access regardless of vCPU CPL. But this also means that SMAP
> violation should be raised based on host CR4.SMAP value and not vCPU CR4.SMAP value as KVM code checks.
> 
> Furthermore, vCPU CPL of guest doesn’t need to be 3 in order to trigger this Errata.

Under the conditions in the code, if CPL were <3 then the SMAP fault
would have been sent to the guest.  But I agree that if we need to
change it to check host CR4, then the CPL of the guest should not be
checked.

Paolo

> It’s only important that guest page-tables maps the guest RIP as user-accessible. i.e. U/S bit in PTE set to 1.

