Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D987C5ECD7C
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 21:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiI0T7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 15:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiI0T7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 15:59:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26DB1C26EF
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 12:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664308752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dx5HDOePnyxgHzqa6DOD5MnqegsYWwrLtgMoZQ1P8dI=;
        b=OZ9/23BTvKP786RkcnXIdeMb7F6oyiy3NTV7Z36oQR7lbXRVizuDXj37K2LIiSx+yP2fjY
        sxPNr4MxwbeuHNPX77a8x8A3555KAdSOSD5WCzpx1ldvuTANIcR5m/vO49GbMd4uGeeQKy
        7HA86eD6PRaxdaXsGL0I5BIsEQHSae4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-360-z-dHoY9fMQuzeQh6DAogsw-1; Tue, 27 Sep 2022 15:59:09 -0400
X-MC-Unique: z-dHoY9fMQuzeQh6DAogsw-1
Received: by mail-wm1-f70.google.com with SMTP id h187-20020a1c21c4000000b003b51369ff1bso7081711wmh.3
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 12:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=Dx5HDOePnyxgHzqa6DOD5MnqegsYWwrLtgMoZQ1P8dI=;
        b=Q1y4oEbnt0i5FOwdCS+xGdhfFwJs0NFDDRdYlzte5z8jxBnWZn6/xMX+9yhwdFDy13
         tdUOJzwa5Ctgc16hbJOJfyKV78WFRqDLjJR/6FBgXXhQTBidRLASG+1VBUxcTWWJ0WI0
         9Vmglnq6elVB/qADVbZXyUQAKrj1o9jn6yx3SSCIgBNOTRhhWlL3W9ZBom3LxlCb3VIs
         OlXZlYaCxsyl3rc+6I5YwnaI/mv1Jy+Ljeg+3mUvIovjAT4xFRiVCzfeRcCFzZ1uoPOE
         3T4p0OJugI+7/VbuHfEExcdDVurtyWWgOrGyV9+6JaSzemxwt4l0txx0qc61oqAiJkIz
         nnbg==
X-Gm-Message-State: ACrzQf06ig75nneJ3UuTaWCOa2OFwgmc5qdUmI2ZtGzLmM5U29j8MVgb
        Uq1qtSMtFMg0AcDk6scu2V+DsSLzYsS+HKEgjl+tUc6LuQ2Nh0sfdER90hgWKZ8MDKLYX2DcnYn
        7w/nH4ieGo6IC
X-Received: by 2002:a05:6000:1a8a:b0:22a:33aa:a907 with SMTP id f10-20020a0560001a8a00b0022a33aaa907mr17893663wry.322.1664308748211;
        Tue, 27 Sep 2022 12:59:08 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7eOWYFV9iprtkvNGfif9TK9/JHNd5re5oxCk70ig0yrmbrjCmGTXstvwdg4i4Hc1mUWp0nvA==
X-Received: by 2002:a05:6000:1a8a:b0:22a:33aa:a907 with SMTP id f10-20020a0560001a8a00b0022a33aaa907mr17893654wry.322.1664308747882;
        Tue, 27 Sep 2022 12:59:07 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-40.dyn.eolo.it. [146.241.104.40])
        by smtp.gmail.com with ESMTPSA id f12-20020a05600c4e8c00b003b33943ce5esm17310012wmq.32.2022.09.27.12.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 12:59:07 -0700 (PDT)
Message-ID: <6502e1a45526f97a1e6d7d27bbe07e3bb3623de3.camel@redhat.com>
Subject: Re: [PATCH net-next 0/4] shrink struct ubuf_info
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Sep 2022 21:59:06 +0200
In-Reply-To: <c06897d4-4883-2756-87f9-9b10ab495c43@gmail.com>
References: <cover.1663892211.git.asml.silence@gmail.com>
         <7fef56880d40b9d83cc99317df9060c4e7cdf919.camel@redhat.com>
         <021d8ea4-891c-237d-686e-64cecc2cc842@gmail.com>
         <bbb212f6-0165-0747-d99d-b49acbb02a80@gmail.com>
         <85cccb780608e830024fc82a8e4f703031646f4e.camel@redhat.com>
         <c06897d4-4883-2756-87f9-9b10ab495c43@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-09-27 at 19:48 +0100, Pavel Begunkov wrote:
> On 9/27/22 18:56, Paolo Abeni wrote:
> > On Tue, 2022-09-27 at 18:16 +0100, Pavel Begunkov wrote:
> > > On 9/27/22 15:28, Pavel Begunkov wrote:
> > > > Hello Paolo,
> > > > 
> > > > On 9/27/22 14:49, Paolo Abeni wrote:
> > > > > Hello,
> > > > > 
> > > > > On Fri, 2022-09-23 at 17:39 +0100, Pavel Begunkov wrote:
> > > > > > struct ubuf_info is large but not all fields are needed for all
> > > > > > cases. We have limited space in io_uring for it and large ubuf_info
> > > > > > prevents some struct embedding, even though we use only a subset
> > > > > > of the fields. It's also not very clean trying to use this typeless
> > > > > > extra space.
> > > > > > 
> > > > > > Shrink struct ubuf_info to only necessary fields used in generic paths,
> > > > > > namely ->callback, ->refcnt and ->flags, which take only 16 bytes. And
> > > > > > make MSG_ZEROCOPY and some other users to embed it into a larger struct
> > > > > > ubuf_info_msgzc mimicking the former ubuf_info.
> > > > > > 
> > > > > > Note, xen/vhost may also have some cleaning on top by creating
> > > > > > new structs containing ubuf_info but with proper types.
> > > > > 
> > > > > That sounds a bit scaring to me. If I read correctly, every uarg user
> > > > > should check 'uarg->callback == msg_zerocopy_callback' before accessing
> > > > > any 'extend' fields.
> > > > 
> > > > Providers of ubuf_info access those fields via callbacks and so already
> > > > know the actual structure used. The net core, on the opposite, should
> > > > keep it encapsulated and not touch them at all.
> > > > 
> > > > The series lists all places where we use extended fields just on the
> > > > merit of stripping the structure of those fields and successfully
> > > > building it. The only user in net/ipv{4,6}/* is MSG_ZEROCOPY, which
> > > > again uses callbacks.
> > > > 
> > > > Sounds like the right direction for me. There is a couple of
> > > > places where it might get type safer, i.e. adding types instead
> > > > of void* in for struct tun_msg_ctl and getting rid of one macro
> > > > hiding types in xen. But seems more like TODO for later.
> > > > 
> > > > > AFAICS the current code sometimes don't do the
> > > > > explicit test because the condition is somewhat implied, which in turn
> > > > > is quite hard to track.
> > > > > 
> > > > > clearing uarg->zerocopy for the 'wrong' uarg was armless and undetected
> > > > > before this series, and after will trigger an oops..
> > > > 
> > > > And now we don't have this field at all to access, considering that
> > > > nobody blindly casts it.
> > > > 
> > > > > There is some noise due to uarg -> uarg_zc renaming which make the
> > > > > series harder to review. Have you considered instead keeping the old
> > > > > name and introducing a smaller 'struct ubuf_info_common'? the overall
> > > > > code should be mostly the same, but it will avoid the above mentioned
> > > > > noise.
> > > > 
> > > > I don't think there will be less noise this way, but let me try
> > > > and see if I can get rid of some churn.
> > > 
> > > It doesn't look any better for me
> > > 
> > > TL;DR; This series converts only 3 users: tap, xen and MSG_ZEROCOPY
> > > and doesn't touch core code. If we do ubuf_info_common though I'd need
> > > to convert lots of places in skbuff.c and multiple places across
> > > tcp/udp, which is much worse.
> > 
> > Uhmm... I underlook the fact we must preserve the current accessors for
> > the common fields.
> > 
> > I guess something like the following could do (completely untested,
> > hopefully should illustrate the idea):
> > 
> > struct ubuf_info {
> > 	struct_group_tagged(ubuf_info_common, common,
> > 		void (*callback)(struct sk_buff *, struct ubuf_info *,
> >                           bool zerocopy_success);
> > 		refcount_t refcnt;
> > 	        u8 flags;
> > 	);
> > 
> > 	union {
> >                  struct {
> >                          unsigned long desc;
> >                          void *ctx;
> >                  };
> >                  struct {
> >                          u32 id;
> >                          u16 len;
> >                          u16 zerocopy:1;
> >                          u32 bytelen;
> >                  };
> >          };
> > 
> >          struct mmpin {
> >                  struct user_struct *user;
> >                  unsigned int num_pg;
> >          } mmp;
> > };
> > 
> > Then you should be able to:
> > - access ubuf_info->callback,
> > - access the same field via ubuf_info->common.callback
> > - declare variables as 'struct ubuf_info_commom' with appropriate
> > contents.
> > 
> > WDYT?
> 
> Interesting, I didn't think about struct_group, this would
> let to split patches better and would limit non-core changes.
> But if the plan is to convert the core helpers to
> ubuf_info_common, than I think it's still messier than changing
> ubuf providers only.
> 
> I can do the exercise, but I don't really see what is the goal.
> Let me ask this, if we forget for a second how diffs look,
> do you care about which pair is going to be in the end?

Uhm... I proposed this initially with the goal of remove non fuctional
changes from a patch that was hard to digest for me (4/4). So it's
about diffstat to me ;) 

On the flip side the change suggested would probably not be as
straighforward as I would hope for.

> ubuf_info_common/ubuf_info vs ubuf_info/ubuf_info_msgzc?

The specific names used are not much relevant.

> Are there you concerned about naming or is there more to it?

I feel like this series is potentially dangerous, but I could not spot
bugs into the code. I would have felt more relaxed eariler in the devel
cycle.

Cheers,

Paolo

