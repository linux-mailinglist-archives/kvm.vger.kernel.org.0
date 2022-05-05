Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F1B51C5D1
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 19:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349759AbiEERMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 13:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382377AbiEERMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 13:12:18 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD595C860
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 10:08:38 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 7so4076563pga.12
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 10:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uBNCKxvmD2AgiNs6UtG7Z6xeP7ZYoOXy6b2j7MDXML4=;
        b=ICh9pg+4NMm9VwAozwf7MBdoT5RR1sDAfc19D8TnIIyvW4wERqBbVGxrEYT/LHsayh
         aFCyJWskiqfEuFR7+rD6qRxTtNVoP+I06n8Dl9hwPIjhyFhrFAKUrtE79pC6Z3Lq2vTy
         P1rJU/hX3wJ8A/wVCy4wv4eV/T1pLi6jbEINMcnSOcws4H1ctr7mNnPzEjxNZ26AtDzK
         1F2enXfgtBCElzxMIW98/nrZSTIszjgIcj+lP0P3hgiCALLL8geBibiMAIDvfZoAOwdC
         F5gnk3D9mtZ0UfyEGYS0SstCY1rML4Xx7/YRIicFuzj1qVxgZpOOI+N+2wxeMhw1AmeA
         HMkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uBNCKxvmD2AgiNs6UtG7Z6xeP7ZYoOXy6b2j7MDXML4=;
        b=G9FzcpnJHcIklqfSe8wD4MReURB43cKpYVw7LzNC2cEEZ2Y9VeKfn5Trumx2z+C2Z1
         2qhT7YsiqxkuQqN0l11lWhzOadPUHtmMdzL2ztcfkm2WUy325jMg4DNXe4Z0l+knUS0U
         ObW/+lsdCS8eumgm4l5x5NKL52UpzlB5dU53tPdXxz0DHWMEW8p+YUNCPV6tMvJK+Qy5
         uMDy66vyi8/Fow0RDgF11lrO+Ub4ARHuo5hfAza/uug3sMCwySdL97c6FfJ2I0P8uUBJ
         JLy9Uvijt4H2hAHEnoKmGcQ2fjkARxl897XgyXV1oUdac0sxmp+kD4fgSbP6Ibnh7RaG
         riiA==
X-Gm-Message-State: AOAM532YNCVq7X8UB6hCoa9NJizvF+RumfDnkl1JSY58PFE7j6spOfdi
        VzRGsAYO1PWnvs5pdYumIr+uOw==
X-Google-Smtp-Source: ABdhPJxFE5V7Oa5RPpyHwM7YEuZTgvyaJPTE9iHSTiV1XcvnVSj0u3YfibFFUuBo7Ay3EaksFGHYmg==
X-Received: by 2002:a63:7d04:0:b0:378:fb34:5162 with SMTP id y4-20020a637d04000000b00378fb345162mr22988866pgc.487.1651770517272;
        Thu, 05 May 2022 10:08:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id be12-20020a056a001f0c00b0050dc76281basm1622739pfb.148.2022.05.05.10.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 10:08:36 -0700 (PDT)
Date:   Thu, 5 May 2022 17:08:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v7 03/11] KVM: selftests: Read binary stats desc in lib
Message-ID: <YnQEkVQJlhTTo6BQ@google.com>
References: <20220503183045.978509-1-bgardon@google.com>
 <20220503183045.978509-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503183045.978509-4-bgardon@google.com>
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

On Tue, May 03, 2022, Ben Gardon wrote:
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 1d75d41f92dc..12fa8cc88043 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2577,3 +2577,41 @@ void read_stats_header(int stats_fd, struct kvm_stats_header *header)
>  	ret = read(stats_fd, header, sizeof(*header));
>  	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
>  }
> +
> +static ssize_t stats_descs_size(struct kvm_stats_header *header)

Please spell out "descriptors", I find it difficult to visually differentiate
desc vs. descs.  I don't mind the short version for variable names, but for helpers
provided by the library I think the added clarity is worth the verbosity.

> +{
> +	return header->num_desc *
> +	       (sizeof(struct kvm_stats_desc) + header->name_size);
> +}

Aha!  This is the right patch to deal with the "variable" name_size.  Rather than
open code the adjustment for header->name_size, add a helper for _that_.  Then
read_stats_descriptors() can do:

	desc_size = get_stats_descriptor_size(header);
	total_size = header->num_desc * get_stats_descriptor_size(header);

	stats_desc = calloc(header->num_desc, desc_size);
	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");

	ret = pread(stats_fd, stats_desc, total_size, header->desc_offset);
	TEST_ASSERT(ret == total_size, "Read KVM stats descriptors");

Those helpers provide an even better place for the comments that my cleanup patch
adds.

> +
> +/*
> + * Read binary stats descriptors
> + *
> + * Input Args:
> + *   stats_fd - the file descriptor for the binary stats file from which to read
> + *   header - the binary stats metadata header corresponding to the given FD
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   A pointer to a newly allocated series of stat descriptors.
> + *   Caller is responsible for freeing the returned kvm_stats_desc.
> + *
> + * Read the stats descriptors from the binary stats interface.
> + */
> +struct kvm_stats_desc *read_stats_desc(int stats_fd,

This be "read_stats_descriptors" (or read_stats_descs() if someone objects to the
verbose name) to make it clear this reads multiple desriptors.

E.g. this on top (compile tested only)

---
 .../selftests/kvm/include/kvm_util_base.h     | 26 +++++++++++++++++--
 .../selftests/kvm/kvm_binary_stats_test.c     |  7 ++---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++---------
 3 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index fabe46ddc1b2..e31f7113a529 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -401,8 +401,30 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void read_stats_header(int stats_fd, struct kvm_stats_header *header);
-struct kvm_stats_desc *read_stats_desc(int stats_fd,
-				       struct kvm_stats_header *header);
+struct kvm_stats_desc *read_stats_descriptors(int stats_fd,
+					      struct kvm_stats_header *header);
+
+static inline ssize_t get_stats_descriptor_size(struct kvm_stats_header *header)
+{
+        /*
+         * The base size of the descriptor is defined by KVM's ABI, but the
+         * size of the name field is variable as far as KVM's ABI is concerned.
+         * But, the size of name is constant for a given instance of KVM and
+         * is provided by KVM in the overall stats header.
+         */
+	return sizeof(struct kvm_stats_desc) + header->name_size;
+}
+
+static inline struct kvm_stats_desc *get_stats_descriptor(struct kvm_stats_desc *stats,
+							  int index,
+							  struct kvm_stats_header *header)
+{
+	/*
+	 * Note, size_desc includes the of the name field, which is
+         * variable, i.e. this is NOT equivalent to &stats_desc[i].
+	 */
+	return (void *)stats + index * get_stats_descriptor_size(header);
+}

 uint32_t guest_get_vcpuid(void);

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index b49fae45db1e..6252e3d6e964 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -35,7 +35,7 @@ static void stats_test(int stats_fd)
 	/* Read kvm stats header */
 	read_stats_header(stats_fd, &header);

-	size_desc = sizeof(*stats_desc) + header.name_size;
+	size_desc = get_stats_descriptor_size(&header);

 	/* Read kvm stats id string */
 	id = malloc(header.name_size);
@@ -63,11 +63,12 @@ static void stats_test(int stats_fd)
 			"Descriptor block is overlapped with data block");

 	/* Read kvm stats descriptors */
-	stats_desc = read_stats_desc(stats_fd, &header);
+	stats_desc = read_stats_descriptors(stats_fd, &header);

 	/* Sanity check for fields in descriptors */
 	for (i = 0; i < header.num_desc; ++i) {
-		pdesc = (void *)stats_desc + i * size_desc;
+		pdesc = get_stats_descriptor(stats_desc, i, &header);
+
 		/* Check type,unit,base boundaries */
 		TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK)
 				<= KVM_STATS_TYPE_MAX, "Unknown KVM stats type");
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 12fa8cc88043..4374c553de1f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2578,12 +2578,6 @@ void read_stats_header(int stats_fd, struct kvm_stats_header *header)
 	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
 }

-static ssize_t stats_descs_size(struct kvm_stats_header *header)
-{
-	return header->num_desc *
-	       (sizeof(struct kvm_stats_desc) + header->name_size);
-}
-
 /*
  * Read binary stats descriptors
  *
@@ -2599,19 +2593,20 @@ static ssize_t stats_descs_size(struct kvm_stats_header *header)
  *
  * Read the stats descriptors from the binary stats interface.
  */
-struct kvm_stats_desc *read_stats_desc(int stats_fd,
-				       struct kvm_stats_header *header)
+struct kvm_stats_desc *read_stats_descriptors(int stats_fd,
+					      struct kvm_stats_header *header)
 {
+	ssize_t ret, desc_size, total_size;
 	struct kvm_stats_desc *stats_desc;
-	ssize_t ret;

-	stats_desc = malloc(stats_descs_size(header));
+	desc_size = get_stats_descriptor_size(header);
+	total_size = header->num_desc * get_stats_descriptor_size(header);
+
+	stats_desc = calloc(header->num_desc, desc_size);
 	TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");

-	ret = pread(stats_fd, stats_desc, stats_descs_size(header),
-		    header->desc_offset);
-	TEST_ASSERT(ret == stats_descs_size(header),
-		    "Read KVM stats descriptors");
+	ret = pread(stats_fd, stats_desc, total_size, header->desc_offset);
+	TEST_ASSERT(ret == total_size, "Read KVM stats descriptors");

 	return stats_desc;
 }

base-commit: 6d8fd8c4f5fa1da6fa63da1d127b2804e79b1092
--

