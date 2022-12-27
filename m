Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D026567B0
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 08:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiL0HGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 02:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiL0HGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 02:06:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91692607
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 23:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672124751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t6B+5aJ0Guf5xJnrVgDQJOLVwGWWIObpNI/iqDeXCf0=;
        b=DMfUiOypcJmoTtD6ujp5Phb/18wh+dg2Glh9K9kVjR6INa49jhtk/B4pddLuYtP03kuLgh
        t4h5PpHdKx8r8KZhHOS6kjCMSfidwzEC2zCWCsXZWc8U1zBeCW8lqx2gtPZvnarpLUeI/U
        Jlk8Y6J3/61KN63Vwajhohp77WuPqxA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-195-m_oWnIBvPwGG_EBNiw4enw-1; Tue, 27 Dec 2022 02:05:47 -0500
X-MC-Unique: m_oWnIBvPwGG_EBNiw4enw-1
Received: by mail-wm1-f70.google.com with SMTP id ay32-20020a05600c1e2000b003d9730391b5so4004010wmb.5
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 23:05:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t6B+5aJ0Guf5xJnrVgDQJOLVwGWWIObpNI/iqDeXCf0=;
        b=HDhSREnIVgnDv2bEsnp8xZea1ICmz/Z6mq+mrO4fiuvOrHD40gEpp0Jkj4AspHHHhA
         hUuplo1epV09B7dARtISGVYktqZhfMkwG7jtMFJ4lWjO2VpIvX0JaG22RYjh44+oiWLh
         LrWxM1i5qYifXl8BmOXw5PbFLD1mop7gf9xrsi1tLfb8SHgY9evjnF6D+zBpm7hyLEIA
         j7DyUxeyCXBZ787qJK1JqkEmw3VDBKXZcmh62yt1WKXlzfj6tJY+hgmYvhxwSCFGE1no
         faeXAwvhRfaK5okz/W2NhLdijY5zdzNQ7JG6MzxBjKA1hNaU2G/As+EzZGzlq7BKJFPZ
         abdg==
X-Gm-Message-State: AFqh2kqfMYhxrq+nniV18egLAyDywVCZ3wKcm75dVdk7wok8SSrjSpNo
        fXN3dx1mr9+q7a2VE/ojBZR8t0t44eAXSUPuJhNH7qizxVfTbzUo59shve8iTjxEo744cNe/5Ba
        apV2IV7EcIjDu
X-Received: by 2002:a05:600c:3789:b0:3d1:f234:12cc with SMTP id o9-20020a05600c378900b003d1f23412ccmr14917377wmr.33.1672124746361;
        Mon, 26 Dec 2022 23:05:46 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv7VxVFTlp1bWTB6ltmdqn/ESzBZWCVVlTMmPA5egsFORFko71Rv1M6SSn/w7ah7B/gMr/N1w==
X-Received: by 2002:a05:600c:3789:b0:3d1:f234:12cc with SMTP id o9-20020a05600c378900b003d1f23412ccmr14917367wmr.33.1672124746164;
        Mon, 26 Dec 2022 23:05:46 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id he11-20020a05600c540b00b003d359aa353csm15894121wmb.45.2022.12.26.23.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 23:05:45 -0800 (PST)
Date:   Tue, 27 Dec 2022 02:05:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Shunsuke Mie <mie@igel.co.jp>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/9] vringh: remove vringh_iov and unite to
 vringh_kiov
Message-ID: <20221227020425-mutt-send-email-mst@kernel.org>
References: <20221227022528.609839-1-mie@igel.co.jp>
 <20221227022528.609839-3-mie@igel.co.jp>
 <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 27, 2022 at 02:04:03PM +0800, Jason Wang wrote:
> On Tue, Dec 27, 2022 at 10:25 AM Shunsuke Mie <mie@igel.co.jp> wrote:
> >
> > struct vringh_iov is defined to hold userland addresses. However, to use
> > common function, __vring_iov, finally the vringh_iov converts to the
> > vringh_kiov with simple cast. It includes compile time check code to make
> > sure it can be cast correctly.
> >
> > To simplify the code, this patch removes the struct vringh_iov and unifies
> > APIs to struct vringh_kiov.
> >
> > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> 
> While at this, I wonder if we need to go further, that is, switch to
> using an iov iterator instead of a vringh customized one.
> 
> Thanks

Possibly, but when doing changes like this one needs to be careful
to avoid breaking all the inlining tricks vringh relies on for
performance.

-- 
MST

