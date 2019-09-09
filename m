Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A69AD61E
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 11:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390054AbfIIJ4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 05:56:12 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36085 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388179AbfIIJ4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 05:56:12 -0400
Received: by mail-ed1-f68.google.com with SMTP id f2so6021024edw.3
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 02:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TkcuSrktiec/3aeNNPIPbr3CY/ViMiJEbi8XPnPDeFE=;
        b=y4Aem2zdEw/0MY0GP//C3Dw/NpPHTs0qKqdBb4xrcHA1pZ0xHXXvj9eCql7CFteyRf
         y4akVA0lJFLoGkrZCPbFNlfznQs3ZbJ9CWr+JuD8Z3kSt7xxylldudDPRN/rQfgO+vW6
         4Pivn2PbcNEY2vN6cCwbQCaHwbvuTKNjsJxKXF06Q624NzL3x+QwiZ8yNorQ6D5vsCJf
         L8tqOz85eAHvcZKFkHNZDRJXs1a4nwiMxGa5yAOxiQQ8VFLx+6VaURSLOJbM9dRa4N2k
         Yb/2g2O7SVOnxZ7wb4kdBg3Pqci3bFH370K9sGIEGhXDnJaqKth32tPYECQ2HLF3tGdq
         JTsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TkcuSrktiec/3aeNNPIPbr3CY/ViMiJEbi8XPnPDeFE=;
        b=IuY/kuCnShLqzdlFTH3xR2HiC9F28nZwJKfa5/exBTXQB1s333hA2RKO09EvHrSK4/
         teY7jphZOr9hy2tD9kBL5x8+2x0lsxaqTWSxd/m5eH3LSX/r3MWKeku77gdmV78Pycsh
         /kF8hUF+OJN3JdVzU0hvUaeyPcLgu304wrQ5kNay0Zip651ZbOc7UNfZl32T79GWmkN/
         iE0xHftih6Tbv5TX+rBC9Cs7H+lohRy8uyFtAyvAPqGklCfQBjplDASeKNPj8Q0Grxv6
         VCkak2VT1ZoVLhH35IQ5ECK8WZvkI3F8JCzbByoRUnEMs/PPFISys0DixN9o/BUiFKDq
         cldQ==
X-Gm-Message-State: APjAAAWWYFjXlR3eMURxS5no3wMdnyK+mT4ZtJJ29Hyi4iJV+aABNKWg
        Ces5enUc+/PPH/NOuCMD+v7/ZQ==
X-Google-Smtp-Source: APXvYqyRn+kl2/TWZQY25cP+eDKMrBVhD4QUydeucAx1gsJCDQV6FE+USGZXHlRVlnYWQyI9ItE3Qw==
X-Received: by 2002:a17:906:5a8d:: with SMTP id l13mr18691711ejq.219.1568022970390;
        Mon, 09 Sep 2019 02:56:10 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id d24sm2946102edp.88.2019.09.09.02.56.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 02:56:09 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 7D24A1003B5; Mon,  9 Sep 2019 12:56:08 +0300 (+03)
Date:   Mon, 9 Sep 2019 12:56:08 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
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
        alexander.h.duyck@linux.intel.com, kirill.shutemov@linux.intel.com
Subject: Re: [PATCH v9 3/8] mm: Move set/get_pcppage_migratetype to mmzone.h
Message-ID: <20190909095608.jwachx3womhqmjbl@box>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190907172528.10910.37051.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907172528.10910.37051.stgit@localhost.localdomain>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 07, 2019 at 10:25:28AM -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> In order to support page reporting it will be necessary to store and
> retrieve the migratetype of a page. To enable that I am moving the set and
> get operations for pcppage_migratetype into the mm/internal.h header so
> that they can be used outside of the page_alloc.c file.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

I'm not sure that it's great idea to export this functionality beyond
mm/page_alloc.c without any additional safeguards. How would we avoid to
messing with ->index when the page is not in the right state of its
life-cycle. Can we add some VM_BUG_ON()s here?

-- 
 Kirill A. Shutemov
