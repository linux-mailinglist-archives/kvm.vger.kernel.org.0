Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99745BBACF
	for <lists+kvm@lfdr.de>; Sun, 18 Sep 2022 00:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiIQWOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Sep 2022 18:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIQWOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Sep 2022 18:14:43 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C451DF50
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 15:14:39 -0700 (PDT)
Date:   Sat, 17 Sep 2022 22:14:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663452877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=03UR8Rb75BZSYr0d5kVIJFfLvNByoIKB6HgMt0K7jCc=;
        b=O10cC5iQonWkynMbdH+AkPZkiDQy2lvCzbV3f2LOXxEcTQwoldqwx/YibwGwOy8uwbFg1R
        YSjUHm5f3CcXbjMdP7V6ZutF+BiBA+FozlYLDKwXqWrFqS/Bro6cEhAK6Ebf+0VxCy6ElS
        Po1XJ1VcDiLRTYY1X4uuQW4bgz427Yg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v6 01/13] KVM: selftests: Add a userfaultfd library
Message-ID: <YyZGx3qMvG71c1y/@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906180930.230218-2-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Tue, Sep 06, 2022 at 06:09:18PM +0000, Ricardo Koller wrote:
> Move the generic userfaultfd code out of demand_paging_test.c into a
> common library, userfaultfd_util. This library consists of a setup and a
> stop function. The setup function starts a thread for handling page
> faults using the handler callback function. This setup returns a
> uffd_desc object which is then used in the stop function (to wait and
> destroy the threads).
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---

[...]

> diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
> new file mode 100644
> index 000000000000..a1a386c083b0
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
> @@ -0,0 +1,46 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * KVM userfaultfd util
> + * Adapted from demand_paging_test.c

nit: Don't reference demand_paging_test.c, as it won't make sense unless
the reader also looks at this diff.

> + *
> + * Copyright (C) 2018, Red Hat, Inc.
> + * Copyright (C) 2019-2022 Google LLC
> + */

[...]

> diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> new file mode 100644
> index 000000000000..4395032ccbe4
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> @@ -0,0 +1,187 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * KVM userfaultfd util
> + * Adapted from demand_paging_test.c
> + *
> + * Copyright (C) 2018, Red Hat, Inc.
> + * Copyright (C) 2019, Google, Inc.
> + * Copyright (C) 2022, Google, Inc.

nit: use the same copyrights as the header file.

With that:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
