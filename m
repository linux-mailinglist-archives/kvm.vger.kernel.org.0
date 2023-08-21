Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F7478363A
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 01:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjHUX25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 19:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjHUX24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 19:28:56 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFFB18B
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 16:28:55 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bf078d5f33so30221705ad.3
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 16:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692660534; x=1693265334;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0GIIQ8yC2eCQt8H9S1hgKT+umlJFOrBWBELG5SVs51g=;
        b=ZMt0mEVN95kO57cG9avlcHac3+5xzWaHbp0SjGcZFM3+F4nns7/B/IerMaQ4od0QHu
         LIQpccGU6ZsKO445s5KTeHAjDc6Tp7iitdlQbkLHV3lkDUN5/sX/KyxXG+mh6ONNWHXp
         3HIdJLTaEQyR8inCml4Oom+u68CZ5wu5NO3u6UHhgLz4JSAD6uOMQWrCYSeBQ2924PCh
         LKLi8fF3LUv7t0k/SlrgRv/2UfAv5yDo3iu8q1/m3US1txnlAYcgQRLbmj/JwhdTviWt
         U8Pd4+6EWDcqfNhBBpMQ0zx//oxkENDMNo7GaM0Blh3yaV4vIFTIlo5e1RaDj2Kzcr8k
         NZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692660534; x=1693265334;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0GIIQ8yC2eCQt8H9S1hgKT+umlJFOrBWBELG5SVs51g=;
        b=E3C7FDW5YVuRJklWmg31oF3z1+HjsJuhhJlQzuOPvC8UCjc2oqlBlXzkYiU3G5uyrH
         sx/X1l+wka0ZtlwP5on5BJTOUKRS7ROV/cHL04eGM5ujusuyWtRDiNJhGkp1DG4eH3Nd
         /cFZ4P+SjKDQvwQ4Mm6v3wbZbT3powRsHS1DD+ykE/+oJc86QisdEPQMEFgp0QHTLlCv
         KwZcaQfbO62NAsHbfFq+vOu59gkFUlJ5jNS++JYdV+fXP8S7CKwcQCSFB2yTDST5ZWVa
         QKKHzLMzaIok1+t20i6Gjym98NnkptddNaQEqW3jzLWL5ZgcNWhLLaKDRMLqEPHZiu5m
         /RIQ==
X-Gm-Message-State: AOJu0YzAtWUgRkS/xWt+fGZdSdfeOq4AlZyDk5mWHKkCrDLdkrf6HTz9
        zlBJb5+sbx4Y+d2Mwj1YzLCoaTBMoh+hdQ==
X-Google-Smtp-Source: AGHT+IEm+XVmoxn/BJwXRXpEsa4bbuU4jtR3+ln2ikN92psace5xnAEU/6WPclXMbx90UNfsusnCUA==
X-Received: by 2002:a17:902:e5cd:b0:1b0:f8:9b2d with SMTP id u13-20020a170902e5cd00b001b000f89b2dmr8733682plf.29.1692660534595;
        Mon, 21 Aug 2023 16:28:54 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902e5c900b001bba3a4888bsm7590514plf.102.2023.08.21.16.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 16:28:53 -0700 (PDT)
Date:   Mon, 21 Aug 2023 16:28:52 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 19/58] qom: implement property helper for sha384
Message-ID: <20230821232852.GC3642077@ls.amr.corp.intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-20-xiaoyao.li@intel.com>
 <ZOMtj0La71zf/uGd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZOMtj0La71zf/uGd@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023 at 10:25:35AM +0100,
"Daniel P. Berrangé" <berrange@redhat.com> wrote:

> On Fri, Aug 18, 2023 at 05:50:02AM -0400, Xiaoyao Li wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Implement property_add_sha384() which converts hex string <-> uint8_t[48]
> > It will be used for TDX which uses sha384 for measurement.
> 
> I think it is likely a better idea to use base64 for the encoding
> the binary hash - we use base64 for all the sev-guest properties
> that were binary data.
> 
> At which points the property set/get logic is much simpler as it
> is just needing a call to  g_base64_encode / g_base64_decode and
> length validation for the decode case.

Hex string is poplar to show hash value, isn't it?  Anyway it's easy for human
operator, shell scripts, libvirt or whatever to convert those representations
with utility commands like base64 or xxd, or library call.  Either way would
work.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>
