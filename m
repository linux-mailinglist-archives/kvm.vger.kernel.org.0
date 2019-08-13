Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB838C207
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 22:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfHMURS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 16:17:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33679 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfHMURS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 16:17:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so109059663wru.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 13:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xLqB1iHsnjstXwaiMKShyj00W23FVz4l/tiZwn13DNg=;
        b=CD4T5zEE53LhgNuS2KUQILkqQwMMgSe6WL5/7wxvrF+Q3fh3DkynHsg+rJjJPgfJwj
         Xq3N515yg2kew2f8l/CEQuZJh+uflu+6krmHZaNYSWLwsnopQB1adT8jv54recMPtE8g
         TuEsnzufuwy6Ue0nSmXR7Cwv5S+fRUhhZttBisTD2J4YtL92DZH5r1Y4Juss21DFfjNx
         7x6mj+sayqDsIfCEZBW7rKjU7zkSaplneSYjTlPnUx8Wf3ZxlheqgFpm5MGRtf9n5dcQ
         1riW266siksyJlr2WKhC753ANMke54NKcS6fvcqeC279k5CgxtOYIVtxxbFLvTzz38w+
         /aFw==
X-Gm-Message-State: APjAAAVjT0SOKQgP3w59/csjJh/dicfGFcytbE8mv/av9FIJ04sdP7Jb
        m4gW7wn0h/Vx7IbPOuHeDO9Kdw==
X-Google-Smtp-Source: APXvYqzp0rrfeaSg7ovOyhbIMVvBcqf42VfsAkGU431CuFYIXFBgFQnuBHDzMSsNaKLpDL8fUR0Iig==
X-Received: by 2002:adf:dc51:: with SMTP id m17mr2040964wrj.256.1565727435844;
        Tue, 13 Aug 2019 13:17:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5193:b12b:f4df:deb6? ([2001:b07:6468:f312:5193:b12b:f4df:deb6])
        by smtp.gmail.com with ESMTPSA id h97sm39854573wrh.74.2019.08.13.13.17.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 13:17:15 -0700 (PDT)
Subject: Re: [Question-kvm] Can hva_to_pfn_fast be executed in interrupt
 context?
To:     Bharath Vedartham <linux.bhar@gmail.com>, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, khalid.aziz@oracle.com
References: <20190813191435.GB10228@bharath12345-Inspiron-5559>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <54182261-88a4-9970-1c3c-8402e130dcda@redhat.com>
Date:   Tue, 13 Aug 2019 22:17:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813191435.GB10228@bharath12345-Inspiron-5559>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 21:14, Bharath Vedartham wrote:
> Hi all,
> 
> I was looking at the function hva_to_pfn_fast(in virt/kvm/kvm_main) which is 
> executed in an atomic context(even in non-atomic context, since
> hva_to_pfn_fast is much faster than hva_to_pfn_slow).
> 
> My question is can this be executed in an interrupt context? 

No, it cannot for the reason you mention below.

Paolo

> The motivation for this question is that in an interrupt context, we cannot
> assume "current" to be the task_struct of the process of interest.
> __get_user_pages_fast assume current->mm when walking the process page
> tables. 
> 
> So if this function hva_to_pfn_fast can be executed in an
> interrupt context, it would not be safe to retrive the pfn with
> __get_user_pages_fast. 
> 
> Thoughts on this?
> 
> Thank you
> Bharath
> 

