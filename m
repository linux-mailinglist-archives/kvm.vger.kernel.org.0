Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4779BABED8
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 19:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395230AbfIFRgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 13:36:38 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33256 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfIFRgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 13:36:38 -0400
Received: by mail-ot1-f67.google.com with SMTP id g25so5209726otl.0
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 10:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9q7uSrbhx9c5SQPYOEpNGzEqta+u5/vhXzE4QY3PuYk=;
        b=1xeDdxfLX0lsqrWJIjHKNvQ2mty+7kFEPueFcWSm7X+Uw/SIvO7sDyfqh+AfqAS86z
         wVdDeFcyAhtSZVSbwU1iw2RHcDZR/mb9lCaEbO8RIecoXv4cGE06VgWE8XThIHSdh2uK
         el35f5u7Cih4orBW7d6OL5E6g525/axBpJ1t+jNgcd9MPGZa1JMWfO+gNW4nSjIG7Yel
         +Ldr/Vw3HeWdYc0ZzT3IOFNWeA3Y8tM1ZzNN5aEk2UU57rg7816BPhyg6HvNe2tyIfEJ
         ZgiD9tfoVAaNOTdIjRjad6b0YzPXCSTAUyCzbdAyXBkgEdgqIkTmCJBxHbHrgZMGew1k
         e9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9q7uSrbhx9c5SQPYOEpNGzEqta+u5/vhXzE4QY3PuYk=;
        b=awYFPkFGF+q76ni1dVsaqkReCZMQPNdKmU16h2FgE6/dBXnzQ9MRBGborCNeZ5GzPQ
         9tYuoYimbvVyfw2zv1PF5buPiY2sKeJI2l03HKobiK61/0+wh5Gl3xnn1oG0zxeAMeM5
         4V668NfCwg0uijhIKClA7mRg55RmoqxMNfuZctHTf4cBpB3jPucOHJsAir7rr/pmoJq2
         4OKhH9SpMx+yYT4PuV+Q4C8Ei2fUU2LZIq+32I4ftHy7Ssteox9pwVAGBACdfs9oLbNm
         H03o603PXNxbcT3PvsZrtOCzBqk6oJUWnpI9H48wpdPgmrGshWolqrv5v+KnY3qibsW2
         7Xqw==
X-Gm-Message-State: APjAAAVgx6YK+WAYHhpQNULwpcR11Jm0rPVDOiFYXi7UvwP5l2zI7AXY
        JTgW8WZzO+R2W/HtApExUsl9DXn1R0sKxhQRzRvEDw==
X-Google-Smtp-Source: APXvYqyOD0SaICilU+ItDzyAjDJkuOCP1Wrc86Psdszc/WfYmakgphsYB7srn4wzOxwYsCcwbO5QfPkMEm4wQHJN9Z0=
X-Received: by 2002:a9d:5ccc:: with SMTP id r12mr7873840oti.71.1567791397118;
 Fri, 06 Sep 2019 10:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190906145213.32552.30160.stgit@localhost.localdomain> <20190906145333.32552.95238.stgit@localhost.localdomain>
In-Reply-To: <20190906145333.32552.95238.stgit@localhost.localdomain>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 6 Sep 2019 10:36:26 -0700
Message-ID: <CAPcyv4hjDpd63f1oYRUHkUjF-E_zJDfY1C36tM5LS=W+QbeRcg@mail.gmail.com>
Subject: Re: [PATCH v8 2/7] mm: Adjust shuffle code to allow for future coalescing
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nitesh@redhat.com, KVM list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtio-dev@lists.oasis-open.org,
        Oscar Salvador <osalvador@suse.de>, yang.zhang.wz@gmail.com,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 6, 2019 at 7:53 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>
> Move the head/tail adding logic out of the shuffle code and into the
> __free_one_page function since ultimately that is where it is really
> needed anyway. By doing this we should be able to reduce the overhead
> and can consolidate all of the list addition bits in one spot.

Looks good, thanks for doing the split:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
