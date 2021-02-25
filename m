Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7AB325A2F
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 00:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhBYX1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 18:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhBYX1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 18:27:53 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C367FC061786
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 15:27:12 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id i8so7787704iog.7
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 15:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5BVyJ8VvhMa5lHXCBOiQO5IyxOHW0ykPgLhaVVKuF7o=;
        b=UWBdQmX5mxAijUdurfYOQi6c43opvi1a/wi/+4KyyiHnJJSuhXhjNw9bYkLjqtkxAs
         vGiJ8MhFQKJ9R0mZ0SxqK1g6dO98KHuEjnrvyhhYaZPQT4+aEocJAmoL4I2Xk8Gohcjc
         qVh2FHH2skEnlBFGnTtXAiStbuFid709J4jHNahXQxocrUXTLcwNI5rjUZEBY8Pswxq5
         LEta9r9H5PHla4jnN4W7I2fatYYsf5emIp+5DRJt63xeOdoGGTrkIt6uFhtLbmM44TiB
         ixQap30K4R0vg3a19ZXZBjIXE2cflvXK/dCudrVp159dl07OXVp8tM2YaqM6PbVX4otY
         4lmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5BVyJ8VvhMa5lHXCBOiQO5IyxOHW0ykPgLhaVVKuF7o=;
        b=j1JBJRo2dntK03JNahvfeSqYx3/lf5s59TiWd7qMOcYqriqXIQjQISJ4g0DMSYHfUB
         RkCeHKRvQFy26mkCkdFtxWOHuaKLIaRFTYs05nlDgTIqok7ANKzzy2oNby95VVjYLTdB
         /VOZX1yt1JLwQhLd5O/RfZ+OuekxGjmDFIRP1XtYXflw/ZQ546+qr6hVi6vTWYTGFRQ1
         cL0SG092qo/qQttOg+uPMjm5mV+X1f+DhfeGQtbT/NOmRnxEm9PI5SWIyYED3L6UTHXE
         CXOD4HvLTL/Yr/wxaUOXAHyOzFkJdKamUi/Z2aocUPsiE5UK0I+4WTDk/3LogmKgMhfN
         5CjQ==
X-Gm-Message-State: AOAM533GHwVDhpQwogFfXtMhoOAGWy+Fc45ERsgRyVHFDkAzASnZzG74
        8QiSuaLRBImAbio/U97rLWaWiw//lV1QFvZZO28izwrAjGk=
X-Google-Smtp-Source: ABdhPJwxP/CvB1vsBhRA6CV3ZO+uz2PjuW+nzH1ZzaEPt9UicnfG7Q8mmt7mINLxqNLB6ZHvaVrOMs5R+ln5kmfDveU=
X-Received: by 2002:a02:30cb:: with SMTP id q194mr159018jaq.57.1614295632018;
 Thu, 25 Feb 2021 15:27:12 -0800 (PST)
MIME-Version: 1.0
References: <20210225055940.18748-1-wangyanan55@huawei.com> <20210225055940.18748-5-wangyanan55@huawei.com>
In-Reply-To: <20210225055940.18748-5-wangyanan55@huawei.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 25 Feb 2021 15:27:00 -0800
Message-ID: <CANgfPd8rSmKr_G9HFqt30hFGJ9jW387yUODYH+f+BUJPv7-sCA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/7] KVM: selftests: Add a helper to get system
 configured THP page size
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     kvm <kvm@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>, Marc Zyngier <maz@kernel.org>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 10:00 PM Yanan Wang <wangyanan55@huawei.com> wrote:
>
> If we want to have some tests about transparent hugepages, the system
> configured THP hugepage size should better be known by the tests, which
> can be used for kinds of alignment or guest memory accessing of vcpus...
> So it makes sense to add a helper to get the transparent hugepage size.
>
> With VM_MEM_SRC_ANONYMOUS_THP specified in vm_userspace_mem_region_add(),
> we now stat /sys/kernel/mm/transparent_hugepage to check whether THP is
> configured in the host kernel before madvise(). Based on this, we can also
> read file /sys/kernel/mm/transparent_hugepage/hpage_pmd_size to get THP
> hugepage size.
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  .../testing/selftests/kvm/include/test_util.h |  2 ++
>  tools/testing/selftests/kvm/lib/test_util.c   | 36 +++++++++++++++++++
>  2 files changed, 38 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index b7f41399f22c..ef24c76ba89a 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -78,6 +78,8 @@ struct vm_mem_backing_src_alias {
>         enum vm_mem_backing_src_type type;
>  };
>
> +bool thp_configured(void);
> +size_t get_trans_hugepagesz(void);
>  void backing_src_help(void);
>  enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
>
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index c7c0627c6842..f2d133f76c67 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -10,6 +10,7 @@
>  #include <limits.h>
>  #include <stdlib.h>
>  #include <time.h>
> +#include <sys/stat.h>
>  #include "linux/kernel.h"
>
>  #include "test_util.h"
> @@ -117,6 +118,41 @@ const struct vm_mem_backing_src_alias backing_src_aliases[] = {
>         {"anonymous_hugetlb", VM_MEM_SRC_ANONYMOUS_HUGETLB,},
>  };
>
> +bool thp_configured(void)
> +{
> +       int ret;
> +       struct stat statbuf;
> +
> +       ret = stat("/sys/kernel/mm/transparent_hugepage", &statbuf);
> +       TEST_ASSERT(ret == 0 || (ret == -1 && errno == ENOENT),
> +                   "Error in stating /sys/kernel/mm/transparent_hugepage: %d",
> +                   errno);
> +
> +       return ret == 0;
> +}
> +
> +size_t get_trans_hugepagesz(void)
> +{
> +       size_t size;
> +       char buf[16];
> +       FILE *f;
> +
> +       TEST_ASSERT(thp_configured(), "THP is not configured in host kernel");
> +
> +       f = fopen("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size", "r");
> +       TEST_ASSERT(f != NULL,
> +                   "Error in opening transparent_hugepage/hpage_pmd_size: %d",
> +                   errno);
> +
> +       if (fread(buf, sizeof(char), sizeof(buf), f) == 0) {
> +               fclose(f);
> +               TEST_FAIL("Unable to read transparent_hugepage/hpage_pmd_size");
> +       }
> +
> +       size = strtoull(buf, NULL, 10);
> +       return size;
> +}
> +
>  void backing_src_help(void)
>  {
>         int i;
> --
> 2.19.1
>
