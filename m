Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBBF779759
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 20:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbjHKSxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 14:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjHKSxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 14:53:06 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096A3A8;
        Fri, 11 Aug 2023 11:53:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1bc6535027aso19921865ad.2;
        Fri, 11 Aug 2023 11:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691779985; x=1692384785;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iq7IkMdomNkVX+bFratX6hcLAj5djkYRdrzjeoPtFbI=;
        b=Ihet3TrNif0RmbgdM8gWevvHC9yikNrioZXXLJV3ixnQelDaxebnNb1rfNrqsW/b7U
         JrjfRWZFfN6rXAkqxzzwevbQVcuBEiwLYOrtUeQOVtmtESQBgSDJVejCCXm3cpm5XL2O
         vQ+G7IsbPVBTnp0PuY+ic3b9YgfHTG2Z28fhDGkP3IL+zQREeQgw24XGaI0JAF++0X03
         UkCGDKFDD9AJ/42nMYslsi35ReyFQjoErEgzgns6i+1NEZJ7U50/K7g0Ew/GOfeQoE9+
         GNmacyZtLT6CQVrfZh6VsKG9NJhWW37+6OfjfcgsDufn1QxTQn8kav0471TlL40YqFO9
         bnuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691779985; x=1692384785;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iq7IkMdomNkVX+bFratX6hcLAj5djkYRdrzjeoPtFbI=;
        b=HcqqZMSDOwJv5mPO+N2PWeH7M+7foSEqy6fp4IyBxNITZwzHBMJjUZ/cEYvPCu0kJI
         bFe6mCgu054WGal+lYsclebZHi9ZEKIfv3adNlCy8YdpR/nAAg526d8J11P4Jcgmg6Yr
         YJ378nqiREoP9UQyzhVuuoFzlLK2A24ZVeTe8HwkDmzXzn6lWafa1VGggZKESZulRK0U
         phHZYFFJNLT6SlU8yp9boARckkobCdsYo/jhwDNq+rDMO3ozFMaFL2fmtEP136HbkhKL
         jpSzZCGuJ0A2bDdhnXVkX0jH9xkXo7t9Eptv54LrEC4PPTMlkJ9qB2m8uzjPEbduT2Q9
         ZS/w==
X-Gm-Message-State: AOJu0YxZZqgmVCPh1GMMju38w5v05AU2MLpEoZsIR+1QUaMyKlONahXm
        T50uKdHoSQvwSXFie5aC/lc=
X-Google-Smtp-Source: AGHT+IGD2JfF0poGxlOFzidHA6O7E/DuwnYdU2IoyyGktUcN0W8zA/mR9nCisUrzfWGaCZj3W8iO1Q==
X-Received: by 2002:a17:902:6bc9:b0:1b0:6e16:b92c with SMTP id m9-20020a1709026bc900b001b06e16b92cmr2609020plt.54.1691779985300;
        Fri, 11 Aug 2023 11:53:05 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b001b03842ab78sm4287554plg.89.2023.08.11.11.53.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Aug 2023 11:53:04 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: [RFC PATCH v2 4/5] mm/autonuma: call .numa_protect() when page is
 protected for NUMA migrate
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230810090048.26184-1-yan.y.zhao@intel.com>
Date:   Fri, 11 Aug 2023 11:52:53 -0700
Cc:     linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>, apopple@nvidia.com,
        Jason Gunthorpe <jgg@nvidia.com>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kevin.tian@intel.com, david@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <8735E3A2-795B-4D52-9634-D48C68645A5D@gmail.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <20230810090048.26184-1-yan.y.zhao@intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
X-Mailer: Apple Mail (2.3731.700.6)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Aug 10, 2023, at 2:00 AM, Yan Zhao <yan.y.zhao@intel.com> wrote:
>=20
> Call mmu notifier's callback .numa_protect() in change_pmd_range() =
when
> a page is ensured to be protected by PROT_NONE for NUMA migration =
purpose.

Consider squashing with the previous patch. It=E2=80=99s better to see =
the user
(caller) with the new functionality.

It would be useful to describe what the expected course of action that
numa_protect callback should take.

