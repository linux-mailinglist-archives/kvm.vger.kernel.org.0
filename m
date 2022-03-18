Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897484DE291
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 21:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240668AbiCRUfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 16:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbiCRUfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 16:35:15 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F90B30CA90
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:33:56 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so9307773pjl.4
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tFfFbJf1vAzHljyR7C3YDseHim9j7bwqTrFQGi3jIro=;
        b=Q1r4h8RaITr0aQCjF1QZKsJYT4DciEIrKNHByQIkdr5xZAtIQY9W+Iewcgbbvysj83
         Pdx0ShXzhwsSac/OGeXzsaTACCyvI4f0aZWp0ndP8zwjyApE0mtm2k2pXjr/dSvor7IN
         pxyKhMDdJaWrGRxh6gV0T28SBjAdC/L19iLJH6OR1i4ggzGkNLGFvi/+KBmyq6i6AXLw
         9bDABdk+9eJDqszmbZKq1lvlRMB5b3B0O8EUQGVoUBWnC5zSxCGin5Fzolm/Qrbw8iuJ
         R86Km71oE7uzBfxRM2tH9673s84i269FK9h+yP5hNsWnPp8323LwrCsInRpVWt1TOFg2
         WyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tFfFbJf1vAzHljyR7C3YDseHim9j7bwqTrFQGi3jIro=;
        b=nJe/E8map3cbKcWJioR6etLhNlsPqWhgi6D+zZqTaXPklKoQsgcbGEvazCLgkkQfDp
         zIahWHvB3mQKy275U4Oxp908qo9uVvIaPOnuaAcV9LLH6NzTF/47hFbSiG+SetSLC37y
         bDLlywo/2vxVUAxr8GcnXnmIx/4KpiqpwHda5uVz1VJu3FPw6fw0Rpi5e2teLgUqX1wx
         X+/OyJrC4t20LZ+8KTkHjfNthBDDmluDjpLjB7ne9R0/IX/9VS86hSBkz9Lqvtt/fCPo
         jZ3KrsCCKcXjJk6g99MKwJKB5dZf3vdAlhq6QzVQxIMNNtn9+8hkKN+/db5FaULwNjk+
         27WQ==
X-Gm-Message-State: AOAM5320u85XePSCMZfh9sB5+uGHEEX7z2dpbQItaiS5L5yFBHRI8RsC
        qf5BxP+V9DOrmKeOJpZaFMcMhA==
X-Google-Smtp-Source: ABdhPJyheeKWO7KDs5dTxcfDqqgwhhv6TVeXcbIYcFgjfaoP5aRQlihVxPCV2xg2xLTxORXmiGB4TQ==
X-Received: by 2002:a17:902:f64d:b0:14f:fb63:f1a with SMTP id m13-20020a170902f64d00b0014ffb630f1amr1249332plg.159.1647635635754;
        Fri, 18 Mar 2022 13:33:55 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id r1-20020a17090a560100b001bf72b5af97sm8810827pjf.13.2022.03.18.13.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:33:55 -0700 (PDT)
Date:   Fri, 18 Mar 2022 13:33:51 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH 06/11] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
Message-ID: <YjTsr3zPilDvHIF1@google.com>
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-7-ricarkol@google.com>
 <CANgfPd9d=C65y=hbpcf5y68d=u+p0LTtk3OO+q8reGmjv8TEEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9d=C65y=hbpcf5y68d=u+p0LTtk3OO+q8reGmjv8TEEg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 12:09:44PM -0600, Ben Gardon wrote:
> On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Deleting a memslot (when freeing a VM) is not closing the backing fd,
> > nor it's unmapping the alias mapping. Fix by adding the missing close
> > and munmap.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index ae21564241c8..c25c79f97695 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -702,6 +702,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
> >         sparsebit_free(&region->unused_phy_pages);
> >         ret = munmap(region->mmap_start, region->mmap_size);
> >         TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> > +       if (region->fd >= 0) {
> > +       /* There's an extra map if shared memory. */
> 
> Nit: indentation

Will fix in v2.

Thanks for the reviews!
> 
> > +               ret = munmap(region->mmap_alias, region->mmap_size);
> > +               TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> > +               close(region->fd);
> > +       }
> >
> >         free(region);
> >  }
> > --
> > 2.35.1.723.g4982287a31-goog
> >
