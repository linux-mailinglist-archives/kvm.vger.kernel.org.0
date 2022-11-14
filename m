Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D46F628592
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 17:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237838AbiKNQix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 11:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237804AbiKNQie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 11:38:34 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58C6615E
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 08:33:32 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id k5so10776997pjo.5
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 08:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ogg3fkQdFokCHIT301Mq6G/d+Jry/0mkt1THzib8yw=;
        b=mfNuf5Wcxgjz9PTOA5OSLw7PSE41L3k++R9MQmsMRXZMhjr1srhCOJNkxaRdcyzn+I
         gvaI1WLik/o55695AmtDTFQguCun+btFWxF34ACKPuL5I7eeDcF760Rz5M7yo6vzoG4i
         uBlMImfVG2oAiZM6pd+UmVYc2jPTjGaNZjZuK7400f4VsegZoEoKRcLEBVKu57Ph4NTP
         py2sQTrkNGXex50BcqHfMs1nZeiWrkk84BtLSu8/DpgRzuvOlNU6LOQIP76qM4rhkmM8
         j0SMUVlXvlKQbMXfwv+zdx1Nf2u9OFEli4zUST6CtyxFYt89Jg3YEGCPvOzaUSlbo9Si
         xYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ogg3fkQdFokCHIT301Mq6G/d+Jry/0mkt1THzib8yw=;
        b=H93OsR85Czstyf9TudLLUgdVQBZkNd3/nZsBCCOVzSP6u1EaIpmiangnJ4n6Fzqvaj
         hjersZFpxgZxduRmtnanhhtscj8K/i3ABv5z0SUIwAmAcvie6jxS+GY/QZ1i4/QhjAai
         +z14DONTe/FE7cvizVtp7AeOAmlpQi3Jcv2PaY4OGXBBFpBA8k3UG4dEh03N8et+vnqm
         eoIETNqqSHck0jGuuH9degITOky+zhxmZGH34JD8ckQVs5zlnhS8MA729d7i6fJbxjBu
         Z+d2f9eAaIDuJbzXeUWNoVYWcHgwkZ4RfeihlzGWUdT2s09SAgfigwv821vTwKIjmo36
         RLBg==
X-Gm-Message-State: ANoB5pnyRXDwmTcWv+SaNch2NIOTQ/shx8JuzzUiQ07HtrVBAN+qA4ro
        vwebjg4pUhFGXs2cPVrwKPBGtXd7HNWG6A==
X-Google-Smtp-Source: AA0mqf6Z7m4Z6nj8jAbKD4bNk9rSQVf+7mwebNI0vAN2YrFaFZCMxDD8FTVLAusqyFuI1Z7b/s4RmQ==
X-Received: by 2002:a17:90a:fb58:b0:213:2230:96d0 with SMTP id iq24-20020a17090afb5800b00213223096d0mr14222680pjb.136.1668443611640;
        Mon, 14 Nov 2022 08:33:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b00186b9196cbesm7778380plg.249.2022.11.14.08.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 08:33:31 -0800 (PST)
Date:   Mon, 14 Nov 2022 16:33:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Woodhouse, David" <dwmw@amazon.co.uk>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mhal@rbox.co" <mhal@rbox.co>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kaya, Metin" <metikaya@amazon.co.uk>
Subject: Re: [PATCH 03/16] KVM: x86: set gfn-to-pfn cache length consistently
 with VM word size
Message-ID: <Y3Jt11kcj8lQ+NCN@google.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
 <20221027161849.2989332-4-pbonzini@redhat.com>
 <Y1q+a3gtABqJPmmr@google.com>
 <c61f6089-57b7-e00f-d5ed-68e62237eab0@redhat.com>
 <c30b46557c9c59b9f4c8c3a2139bd506a81f7ee1.camel@infradead.org>
 <994314051112513787cc4bd0c7d2694e15190d0f.camel@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <994314051112513787cc4bd0c7d2694e15190d0f.camel@amazon.co.uk>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022, Woodhouse, David wrote:
> Most other data structures, including the pvclock info (both Xen and
> native KVM), could potentially cross page boundaries. And isn't that
> also true for things that we'd want to use the GPC for in nesting?

Off the top of my head, no.  Except for MSR and I/O permission bitmaps, which
are >4KiB, things that are referenced by physical address are <=4KiB and must be
naturally aligned.  nVMX does temporarily map L1's MSR bitmap, but that could be
split into two separate mappings if necessary.

> For the runstate info I suggested reverting commit a795cd43c5b5 but
> that doesn't actually work because it still has the same problem. Even
> the gfn-to-hva cache still only really works for a single page, and
> things like kvm_write_guest_offset_cached() will fall back to using
> kvm_write_guest() in the case where it crosses a page boundary.
> 
> I'm wondering if the better fix is to allow the GPC to map more than
> one page.

I agree that KVM should drop the "no page splits" restriction, but I don't think
that would necessarily solve all KVM Xen issues.  KVM still needs to precisely
handle the "correct" struct size, e.g. if one of the structs is placed at the very
end of the page such that the smaller compat version doesn't split a page but the
64-bit version does.
