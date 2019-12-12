Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002B211C139
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 01:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfLLAWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 19:22:01 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30429 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727109AbfLLAWB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 19:22:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576110120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ska3bIPmsdQtnj/4meb46bcvVz/4NO14TTW8PGBXyDI=;
        b=ept2QLrM2quCQFoRtTS5dc6YZfJe09iZpgfiMyYl4py3asp3ouNdEhlWxqkjgcHgSTytDo
        TeeVyozkjFgHR0U6O8IfvMsXrUlOEmkcm+MIGavAZAR/L9Q/XJmL9Iudt8CX/G2DGVIY7I
        lQQpaa1X6VWnvqT7yhLgQq+kNE2suwg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-hZBFv7rMNSiwpMpIHC4Xew-1; Wed, 11 Dec 2019 19:21:59 -0500
X-MC-Unique: hZBFv7rMNSiwpMpIHC4Xew-1
Received: by mail-wm1-f71.google.com with SMTP id g26so70751wmk.6
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 16:21:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ska3bIPmsdQtnj/4meb46bcvVz/4NO14TTW8PGBXyDI=;
        b=TRgXqQcVofOLqHYt+BcRC7oa+jWcG2X9ChKUYJEtWkx2vH04cUn2bxcZhnWnOYoNhp
         KKqFtl/CSo0S9t+6tEMgrGuokWXIUWJWL7QzZJG8IqeHPinY4rTj0STGgr4pUKjKm6p2
         Hzhxx9+ofS4FQ2EEcItVlzsj6ztXmQeTHvMWI3oUjUzq1ffpALfsoCg9Dk0KVKIJ6oTz
         UeRCOmeoAlWZ+fnnY1BOHlakK3EWjgO32Pnjmn62YZPh4V2h3pGoDEescJOHjIC9JWtv
         9+Ww1NVw0NCKAs2jElmQtUoHimYzocvHyKknaeblMdEU92Hg/mwlXpn0eUXNqmMTInrl
         J0vw==
X-Gm-Message-State: APjAAAXE0nXB1IAFUz0LVkYqjrca1JrvR8yhh+BAe0qUUQlEB/oOHSO6
        Z8Sm3VKBRSQBOz6IHU3owansndzNJFmeAcW6RH54M6PKU5lWxE18Ypds7EbPCfsVX9ZRj8ovmZX
        u2mRfs734RLFI
X-Received: by 2002:adf:f58a:: with SMTP id f10mr2889590wro.105.1576110118022;
        Wed, 11 Dec 2019 16:21:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqxGJwEdVkyaU2oXUwh6CTh2f90dtYsbxxgMNCxSyknFWlvYkVEzD3KyBhe96t/+ML4ibwigNw==
X-Received: by 2002:adf:f58a:: with SMTP id f10mr2889571wro.105.1576110117837;
        Wed, 11 Dec 2019 16:21:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id c9sm4002416wmc.47.2019.12.11.16.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 16:21:57 -0800 (PST)
Subject: Re: [PATCH v4 2/2] kvm: Use huge pages for DAX-backed files
To:     Barret Rhoden <brho@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
References: <20191211213207.215936-1-brho@google.com>
 <20191211213207.215936-3-brho@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5abef720-c329-13c3-ff93-b4b58a08721c@redhat.com>
Date:   Thu, 12 Dec 2019 01:21:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191211213207.215936-3-brho@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 22:32, Barret Rhoden wrote:
> +	/*
> +	 * Our caller grabbed the KVM mmu_lock with a successful
> +	 * mmu_notifier_retry, so we're safe to walk the page table.
> +	 */
> +	switch (dev_pagemap_mapping_shift(hva, current->mm)) {
> +	case PMD_SHIFT:
> +	case PUD_SIZE:
> +		return true;
> +	}
> +	return false;

Should this simply be "> PAGE_SHIFT"?

Paolo

