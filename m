Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652E68AA98
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 00:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfHLWjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 18:39:23 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36209 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfHLWjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 18:39:23 -0400
Received: by mail-ot1-f65.google.com with SMTP id k18so33103528otr.3
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2019 15:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3aW5whQDJuBeImZ/vm/gZQhI4k4oQ8vroJ1EZoWTTJg=;
        b=W5RPcjMy2nSOxlc4JEQN/FwtmfGeYjojp9ZODu4ApD4CFAxXskqe+/tMV9edw9LUdx
         qnlUND2MQlVVlnOu7OGYLgJuZf4cj69zqu/4J89ENTbTDUFhgZrGN1dcouiEGSJDIKTv
         o/JtrRgZ/xJIsXmeC3F8OwvGykjcnMREp0KRFnpgOCL6zagxsRbC5C54aynLQTRDUqYi
         jhXMUGbVLruMjszhZFEpIvilTWNyNkBnr6HlHaN1RHkovoMhGAGAv6/rEmt5BZq726Yv
         kL8Nyzc4obRWZMKrP5ghFcL3rhUa8D/iVtsx1IjYskP+I4BJK7OlaRrKsNReR5wsC6RW
         hwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3aW5whQDJuBeImZ/vm/gZQhI4k4oQ8vroJ1EZoWTTJg=;
        b=aNY8Y7SerKQ/jVJOmko/3hq9NNycnXFGDGtqTe1tiPbRopGA9suUpQUJ2UG77u0b5t
         aU3RQF0BqluVIN4wx/NkhVAvZrI/wBVnugvWg5yuX/dHvLkBohvI7vWJrBkk3JjBNKaz
         25Cd6AITaHDDuhtvePcKUvkIXFxmb0MFd91TxqlIthWwOAA0MbHCkVMPJwM2rdIN9v1/
         QlSahHrth9W0ogmgGrwF9OynDoQFCSHO4glmtZjwv4/SfeATMQfedH3tFart2uTgJE1s
         ldH8GEJYZdk0ou3jTpstT91U7czS1CLc2EE4mzuCbJ0zjToJ/2yCYwoMNUmqHhXRDwEI
         wOBA==
X-Gm-Message-State: APjAAAWOHUWoheBCAvv8amoMXrkdRdoTQvUskYzsJAjblVwzj4eQBVr+
        OAOWmWgcmoaeZq+t7YHG1+7EZc/DA7fr+c5M67Pjiw==
X-Google-Smtp-Source: APXvYqyZa9vrGETWKw/3K2ZNQJVHXbpz2NU1cLAvQDyLfoeTJYzgNcrQQuvBKjD9GBMcejKS62NxlzuqZX/kdrrVoDI=
X-Received: by 2002:a9d:7248:: with SMTP id a8mr33233142otk.363.1565649562325;
 Mon, 12 Aug 2019 15:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190812213158.22097.30576.stgit@localhost.localdomain> <20190812213337.22097.66780.stgit@localhost.localdomain>
In-Reply-To: <20190812213337.22097.66780.stgit@localhost.localdomain>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 12 Aug 2019 15:39:11 -0700
Message-ID: <CAPcyv4id6nUNHJxspAWjaLFSPyLM_2jSKAa5PDibqeQXP0yN5w@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] mm: Use zone and order instead of free area in
 free_list manipulators
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

On Mon, Aug 12, 2019 at 2:33 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>
> In order to enable the use of the zone from the list manipulator functions
> I will need access to the zone pointer. As it turns out most of the
> accessors were always just being directly passed &zone->free_area[order]
> anyway so it would make sense to just fold that into the function itself
> and pass the zone and order as arguments instead of the free area.
>
> In order to be able to reference the zone we need to move the declaration
> of the functions down so that we have the zone defined before we define the
> list manipulation functions.

Independent of the code movement for the zone declaration this looks
like a nice cleanup of the calling convention.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
