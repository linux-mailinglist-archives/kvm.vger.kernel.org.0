Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8FD4FC7D6
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 00:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348601AbiDKWxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 18:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243154AbiDKWxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 18:53:17 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BB96576
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 15:51:02 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q142so15407325pgq.9
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 15:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FcTYvvhN5dtue7MzX/+Ct7GWZzfdtrfomwfg98GsSrQ=;
        b=hCcpz68XSqFN0GmAt/laN0bCPIcM3eZc7r4Aoq3sqv1AIAWECh5CAA5MqFbNugpj5a
         VPUs/CZN7juttqOlZxDo1iHJ4GA1ScWYzKQrJ1GmMhY/2AbJs6RpD4H03ij9R+pD4lYQ
         ZhJy/t5DYTW7NRrZpiLU+bGMxaTBBd/mnoNgE7rfG/D7bTAEWyeiZykzE7SbYt1RQw5i
         yK4bg8XNj2tfbtBvUyp4VeU8/T8MlG15kqDb+3DQNWaWcj6XfBsvW+VlYGL88AUCS4WL
         CQEn5IooNK4QdLnPeiR5OVbdOHpo9Rq8sDWHKTUiYhAb0s6L8ZHpxaPzvgCRoKRdhBrs
         ACUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FcTYvvhN5dtue7MzX/+Ct7GWZzfdtrfomwfg98GsSrQ=;
        b=64K5IYdL3QZ80UFJQzF6z2U6q9yFqEWAGPGr8dZpsZQsVeBuJidwvKzXced70S0/6l
         Ds5rBw3OcaGUIFN4OiQvONITaNIBMycYL+874q/SBLkBvqMPwe/ukQMdZmYD3Oznt107
         pS6Usj9tU6cdA6ibRhC9EXIye8luY9p0lKZ8eJqJf4667ZCFS+tQZvepa0rQp+wYFbI2
         bJa0InVg6FmKOc6pBr769psIFNpDheglWKkxx6Xb3KDaZi8JRX1dANQV7xmpABxCyLiy
         30l1sJ3JuCeQKeVqVzI8704vaxOeFjUKL1xWODFoRytTjx5YeIdv3Abmzgtzuu9FUFFI
         RovQ==
X-Gm-Message-State: AOAM531ooqauAma/G07FLf9S2LMvrPrIYiJl4eDwM79zbBRsiKu6Y37H
        jPkTFCyKo2s7AnSbLAe396jyhw==
X-Google-Smtp-Source: ABdhPJxjHamZfjze6EDpUv2KPHV1RVw6Gyy/Qvc+kNL4xIcjX0N3BIoDtwHAto5L4YIXPC0QHz7OTQ==
X-Received: by 2002:a05:6a00:a15:b0:4fb:4112:870e with SMTP id p21-20020a056a000a1500b004fb4112870emr34896218pfh.11.1649717461805;
        Mon, 11 Apr 2022 15:51:01 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id nv11-20020a17090b1b4b00b001c71b0bf18bsm510761pjb.11.2022.04.11.15.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 15:51:01 -0700 (PDT)
Date:   Mon, 11 Apr 2022 22:50:57 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v4 01/10] KVM: selftests: Remove dynamic memory
 allocation for stats header
Message-ID: <YlSw0UXTYqgx4wa3@google.com>
References: <20220411211015.3091615-1-bgardon@google.com>
 <20220411211015.3091615-2-bgardon@google.com>
 <CALzav=d_DB+onkMZmZwEj7yd_gDqg_phqQJpTw0g9ahe3WmvqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=d_DB+onkMZmZwEj7yd_gDqg_phqQJpTw0g9ahe3WmvqA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022, David Matlack wrote:
> On Mon, Apr 11, 2022 at 2:10 PM Ben Gardon <bgardon@google.com> wrote:
> >
> > There's no need to allocate dynamic memory for the stats header since
> > its size is known at compile time.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> 
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  .../selftests/kvm/kvm_binary_stats_test.c     | 58 +++++++++----------
> >  1 file changed, 27 insertions(+), 31 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > index 17f65d514915..dad34d8a41fe 100644
> > --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > @@ -26,56 +26,53 @@ static void stats_test(int stats_fd)
> >         int i;
> >         size_t size_desc;
> >         size_t size_data = 0;
> > -       struct kvm_stats_header *header;
> > +       struct kvm_stats_header header;
> >         char *id;
> >         struct kvm_stats_desc *stats_desc;
> >         u64 *stats_data;
> >         struct kvm_stats_desc *pdesc;
> >
> >         /* Read kvm stats header */
> > -       header = malloc(sizeof(*header));
> > -       TEST_ASSERT(header, "Allocate memory for stats header");
> > -
> > -       ret = read(stats_fd, header, sizeof(*header));
> > -       TEST_ASSERT(ret == sizeof(*header), "Read stats header");
> > -       size_desc = sizeof(*stats_desc) + header->name_size;
> > +       ret = read(stats_fd, &header, sizeof(header));
> > +       TEST_ASSERT(ret == sizeof(header), "Read stats header");
> > +       size_desc = sizeof(*stats_desc) + header.name_size;
> >
> >         /* Read kvm stats id string */
> > -       id = malloc(header->name_size);
> > +       id = malloc(header.name_size);
> >         TEST_ASSERT(id, "Allocate memory for id string");
> > -       ret = read(stats_fd, id, header->name_size);
> > -       TEST_ASSERT(ret == header->name_size, "Read id string");
> > +       ret = read(stats_fd, id, header.name_size);
> > +       TEST_ASSERT(ret == header.name_size, "Read id string");
> >
> >         /* Check id string, that should start with "kvm" */
> > -       TEST_ASSERT(!strncmp(id, "kvm", 3) && strlen(id) < header->name_size,
> > +       TEST_ASSERT(!strncmp(id, "kvm", 3) && strlen(id) < header.name_size,
> >                                 "Invalid KVM stats type, id: %s", id);
> >
> >         /* Sanity check for other fields in header */
> > -       if (header->num_desc == 0) {
> > +       if (header.num_desc == 0) {
> >                 printf("No KVM stats defined!");
> >                 return;
> >         }
> >         /* Check overlap */
> > -       TEST_ASSERT(header->desc_offset > 0 && header->data_offset > 0
> > -                       && header->desc_offset >= sizeof(*header)
> > -                       && header->data_offset >= sizeof(*header),
> > +       TEST_ASSERT(header.desc_offset > 0 && header.data_offset > 0
> > +                       && header.desc_offset >= sizeof(header)
> > +                       && header.data_offset >= sizeof(header),
> >                         "Invalid offset fields in header");
> > -       TEST_ASSERT(header->desc_offset > header->data_offset ||
> > -                       (header->desc_offset + size_desc * header->num_desc <=
> > -                                                       header->data_offset),
> > +       TEST_ASSERT(header.desc_offset > header.data_offset ||
> > +                       (header.desc_offset + size_desc * header.num_desc <=
> > +                                                       header.data_offset),
> >                         "Descriptor block is overlapped with data block");
> >
> >         /* Allocate memory for stats descriptors */
> > -       stats_desc = calloc(header->num_desc, size_desc);
> > +       stats_desc = calloc(header.num_desc, size_desc);
> >         TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
> >         /* Read kvm stats descriptors */
> >         ret = pread(stats_fd, stats_desc,
> > -                       size_desc * header->num_desc, header->desc_offset);
> > -       TEST_ASSERT(ret == size_desc * header->num_desc,
> > +                       size_desc * header.num_desc, header.desc_offset);
> > +       TEST_ASSERT(ret == size_desc * header.num_desc,
> >                         "Read KVM stats descriptors");
> >
> >         /* Sanity check for fields in descriptors */
> > -       for (i = 0; i < header->num_desc; ++i) {
> > +       for (i = 0; i < header.num_desc; ++i) {
> >                 pdesc = (void *)stats_desc + i * size_desc;
> >                 /* Check type,unit,base boundaries */
> >                 TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK)
> > @@ -104,7 +101,7 @@ static void stats_test(int stats_fd)
> >                         break;
> >                 }
> >                 /* Check name string */
> > -               TEST_ASSERT(strlen(pdesc->name) < header->name_size,
> > +               TEST_ASSERT(strlen(pdesc->name) < header.name_size,
> >                                 "KVM stats name(%s) too long", pdesc->name);
> >                 /* Check size field, which should not be zero */
> >                 TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
> > @@ -124,14 +121,14 @@ static void stats_test(int stats_fd)
> >                 size_data += pdesc->size * sizeof(*stats_data);
> >         }
> >         /* Check overlap */
> > -       TEST_ASSERT(header->data_offset >= header->desc_offset
> > -               || header->data_offset + size_data <= header->desc_offset,
> > +       TEST_ASSERT(header.data_offset >= header.desc_offset
> > +               || header.data_offset + size_data <= header.desc_offset,
> >                 "Data block is overlapped with Descriptor block");
> >         /* Check validity of all stats data size */
> > -       TEST_ASSERT(size_data >= header->num_desc * sizeof(*stats_data),
> > +       TEST_ASSERT(size_data >= header.num_desc * sizeof(*stats_data),
> >                         "Data size is not correct");
> >         /* Check stats offset */
> > -       for (i = 0; i < header->num_desc; ++i) {
> > +       for (i = 0; i < header.num_desc; ++i) {
> >                 pdesc = (void *)stats_desc + i * size_desc;
> >                 TEST_ASSERT(pdesc->offset < size_data,
> >                         "Invalid offset (%u) for stats: %s",
> > @@ -142,15 +139,15 @@ static void stats_test(int stats_fd)
> >         stats_data = malloc(size_data);
> >         TEST_ASSERT(stats_data, "Allocate memory for stats data");
> >         /* Read kvm stats data as a bulk */
> > -       ret = pread(stats_fd, stats_data, size_data, header->data_offset);
> > +       ret = pread(stats_fd, stats_data, size_data, header.data_offset);
> >         TEST_ASSERT(ret == size_data, "Read KVM stats data");
> >         /* Read kvm stats data one by one */
> >         size_data = 0;
> > -       for (i = 0; i < header->num_desc; ++i) {
> > +       for (i = 0; i < header.num_desc; ++i) {
> >                 pdesc = (void *)stats_desc + i * size_desc;
> >                 ret = pread(stats_fd, stats_data,
> >                                 pdesc->size * sizeof(*stats_data),
> > -                               header->data_offset + size_data);
> > +                               header.data_offset + size_data);
> >                 TEST_ASSERT(ret == pdesc->size * sizeof(*stats_data),
> >                                 "Read data of KVM stats: %s", pdesc->name);
> >                 size_data += pdesc->size * sizeof(*stats_data);
> > @@ -159,7 +156,6 @@ static void stats_test(int stats_fd)
> >         free(stats_data);
> >         free(stats_desc);
> >         free(id);
> > -       free(header);
> >  }
> >
> >
> > --
> > 2.35.1.1178.g4f1659d476-goog
> >
