Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D8CADDB4
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 19:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbfIIRAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 13:00:40 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40583 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbfIIRAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 13:00:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id v38so13620181edm.7
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 10:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ndNymM6S7tmHE+n2EfAPZaAIl9m2k/Hd15vX5tVSFn0=;
        b=bC1iKUUAEbStsWoLLyFmH5e3Rn8L60J3eOAqn15+XFheVcXT1DobBZSZOvDsKrkPto
         BZiYeUcnpJuBt0piDhdzCsqC3hIod7bQagzUG9EjXBu0ESLXWCVV2X7T0c81KPLM1Uf5
         0f7ixvlLeBdwKRO29lKj8JclH/y5G451SsJIj+y1zKjGQqQ4t1XF2xWUTa0iI02AECtm
         UGFfXMsdzSC33aaEpg621gISPu5F5vPOIUSC4aFqzcjw2P7AvkYRRZ7AgQ3ewr5RQp3C
         b5f90jb1+egIK7q+SbO3Y6RqrcCAr280k27p746RhVM2R7SGmgTERnkk1Axx5L/3rZx+
         Tu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ndNymM6S7tmHE+n2EfAPZaAIl9m2k/Hd15vX5tVSFn0=;
        b=MhDr30qKScFs5BMTSYGWaZIwLSYKOc2At0sTPevSBQdXtIPmgPQgL/pWhSU29bGpEf
         koVIcP5am6Y5rivZVTZqS6MucJcSf8mRE3WB+vth4j+QI5p39Kz4cAFFUS2k4HO5Lh+v
         tl0jrif/55tW1K8hJOIktehNdmahhb+QJBYQBjhMoVSgb9UEswCkqu0wg8Kvf85UZDOi
         YjbLS9xlitUJko+5XmGZtr2oAQF4kUNfLe6+RCqK8hrqcs3fEtb5flEY8m5oK65CRz+7
         c9aKkI1SPQm5rRZhsGhMDoSk2yMj0HP4aVCAz49CaPu849IQrej4AcacsCRh3uoOD29L
         91jA==
X-Gm-Message-State: APjAAAXPraFOt1z3MyNJoLvKaZCY6MVD5WTpLUiKBGqcKepaQf2I1ST0
        RWA5V3Wcg0cXPIfHtdg817fm6XtLY6RUbg==
X-Google-Smtp-Source: APXvYqwrMgzfqO4cc8VaH4OYBbPyjLCLYVUXkYW0y564TeNoEu15jhrHaKYbf96/6CjMmoqhLR3q1Q==
X-Received: by 2002:a17:906:35c2:: with SMTP id p2mr10087253ejb.241.1568048438153;
        Mon, 09 Sep 2019 10:00:38 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id ot4sm1832093ejb.43.2019.09.09.10.00.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 10:00:37 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 4F3861029C4; Mon,  9 Sep 2019 20:00:36 +0300 (+03)
Date:   Mon, 9 Sep 2019 20:00:36 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        kirill.shutemov@linux.intel.com
Subject: Re: [PATCH v9 2/8] mm: Adjust shuffle code to allow for future
 coalescing
Message-ID: <20190909170036.t3gvjar3qjywjquc@box>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190907172520.10910.83100.stgit@localhost.localdomain>
 <20190909094700.bbslsxpuwvxmodal@box>
 <171e0e86cde2012e8bda647c0370e902768ba0b5.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171e0e86cde2012e8bda647c0370e902768ba0b5.camel@linux.intel.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 09, 2019 at 09:43:00AM -0700, Alexander Duyck wrote:
> I'm not sure I follow what you are saying about the free_area definition.
> It looks like it is a part of the zone structure so I would think it still
> needs to be defined in the header.

Yeah, you are right. I didn't noticed this.

-- 
 Kirill A. Shutemov
