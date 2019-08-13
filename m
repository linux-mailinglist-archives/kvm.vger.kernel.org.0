Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92938B35A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 11:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfHMJGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 05:06:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33175 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfHMJGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 05:06:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so107144633wru.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 02:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MRboZnkOwIqMqx46t0ZQ9zepiSGdc691QK9w7wR1ygw=;
        b=ULcch2o/X9bj+6VxnBJkkJoSwXaeugaS/qHrca8v8C6TFdzNS/iYS4aqr4cNhdILrn
         p7N2qVQSidoylYotvJY9B+HrUkLqDUC0hHNIrzW6ADE7OqD5YHJ/9JkbFC/s45xrC9Gu
         fKIpiaesg23I3UWsT0NpJo6eo2Llj4j+IuxQTw/haJ+iaZFlCGRcPUvpQihdst1di6+T
         JaZTbWCO70D/Q35wBEZ1VtS/uglBH8YVULrhRt0tVQZO08aXTiI9PcRc+IhbW4WEpfHt
         8Pkk4k2qfhMqjbSzes3XmMJj5oXJ/wUCe4RZr11AKRGgAstxpu1Je+GUJreDm/be2HtL
         Ga+A==
X-Gm-Message-State: APjAAAXSaqTBFfjYR188PgzhNC7AULY1JB6wvfJWIdTIcyiObU8xZYlR
        BHdlsxS5eCa0mapFO8323v1aoQ==
X-Google-Smtp-Source: APXvYqweK6uM1R3qYisV+zwsl38ikaVzEXE80NEPe0UggCtqMVhBk6tbs9HWluPuTVYiwrckbrYbsA==
X-Received: by 2002:adf:aa8d:: with SMTP id h13mr39037899wrc.307.1565687213313;
        Tue, 13 Aug 2019 02:06:53 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a17sm677722wmm.47.2019.08.13.02.06.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 02:06:52 -0700 (PDT)
Subject: Re: [RFC PATCH v6 27/92] kvm: introspection: use page track
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?B?TmljdciZb3IgQ8OuyJt1?= <ncitu@bitdefender.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-28-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0e6703cd-2d0b-ccd2-c353-c5f5de659837@redhat.com>
Date:   Tue, 13 Aug 2019 11:06:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-28-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 17:59, Adalbert Lazăr wrote:
> +
> +	/*
> +	 * This function uses kvm->mmu_lock so it's not allowed to be
> +	 * called under kvmi_put(). It can reach a deadlock if called
> +	 * from kvm_mmu_load -> kvmi_tracked_gfn -> kvmi_put.
> +	 */
> +	kvmi_clear_mem_access(kvm);

kvmi_tracked_gfn does not exist yet.

More in general, this comment says why you are calling this here, but it
says nothing about the split of responsibility between
kvmi_end_introspection and kvmi_release.  Please add a comment for this
as soon as you add kvmi_end_introspection (which according to my earlier
review should be patch 1).

Paolo
