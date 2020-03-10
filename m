Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5014E17F68C
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 12:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCJLnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 07:43:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53644 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgCJLnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 07:43:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id 25so1017477wmk.3;
        Tue, 10 Mar 2020 04:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hMBSAZ2w6rHBlgdOMKsoKxalij10II+RdrF1ljWYIAk=;
        b=CT1UgkL2egBTV0YLLHJ2dx8KHYyOY16G/v3ksJ6HEA5NbJVa6m/UTmeymOj/Lnjj8t
         pAkXpX1tET5SMewsjbv6udog3l3INkBt1maraDXk4gU5OWh7n/lBBiaFzxpT3lsfGhJp
         Spyxvvndau0hT6sS/pK16SGs9UF4hyXx6m0KQ1uiBahBj8IniJ405lpfTJ4nu46HWu0h
         /KMOwg1LUY6bd2OJUOEGSw2EVMg6eoJKxjGAcj2kWcgIZigr3fbUQcRiq4v0o6Du2LR1
         oJO7PDLHqHdzTmSI5Jro8DniS9Cxg5dDpbLQtgOB0hvHik7cpQbpsUXVoHwE3xU9hnZB
         wtQA==
X-Gm-Message-State: ANhLgQ3mlNcVLKnSAiKnVmPWRbLn0t4EgRpTIXJjSXRuccXvwHI4FTb/
        zSrK9bGK7pyqOE2Vc4//pKM=
X-Google-Smtp-Source: ADFU+vuKZ/41TrYfhsXloC/F2fawinzqxCwHUoA7MsTg/Xb+5sVoVBhrkM90t/0amNfG09qJHc1Ixg==
X-Received: by 2002:a05:600c:d8:: with SMTP id u24mr1820247wmm.165.1583840594393;
        Tue, 10 Mar 2020 04:43:14 -0700 (PDT)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id e20sm4703596wrc.97.2020.03.10.04.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 04:43:13 -0700 (PDT)
Date:   Tue, 10 Mar 2020 12:43:12 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v1 07/11] virtio-mem: Allow to offline partially
 unplugged memory blocks
Message-ID: <20200310114312.GG8447@dhcp22.suse.cz>
References: <20200302134941.315212-1-david@redhat.com>
 <20200302134941.315212-8-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302134941.315212-8-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon 02-03-20 14:49:37, David Hildenbrand wrote:
[...]
> +static void virtio_mem_notify_going_offline(struct virtio_mem *vm,
> +					    unsigned long mb_id)
> +{
> +	const unsigned long nr_pages = PFN_DOWN(vm->subblock_size);
> +	unsigned long pfn;
> +	int sb_id, i;
> +
> +	for (sb_id = 0; sb_id < vm->nb_sb_per_mb; sb_id++) {
> +		if (virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id, 1))
> +			continue;
> +		/*
> +		 * Drop our reference to the pages so the memory can get
> +		 * offlined and add the unplugged pages to the managed
> +		 * page counters (so offlining code can correctly subtract
> +		 * them again).
> +		 */
> +		pfn = PFN_DOWN(virtio_mem_mb_id_to_phys(mb_id) +
> +			       sb_id * vm->subblock_size);
> +		adjust_managed_page_count(pfn_to_page(pfn), nr_pages);
> +		for (i = 0; i < nr_pages; i++)
> +			page_ref_dec(pfn_to_page(pfn + i));

Is there ever situation this might be a different than 1->0 transition?
-- 
Michal Hocko
SUSE Labs
