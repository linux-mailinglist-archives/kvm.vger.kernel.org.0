Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD8F4FE950
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 22:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiDLUJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 16:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiDLUJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 16:09:19 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420E592D05
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:03:19 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso4064592pjb.5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8KkgfUadDs/hkl85C1FLCMdEQpgE7qKS4mK1asC94oc=;
        b=AY3gI6P8RZ+BzfKfXKXW/j47+of/eBKAgtbOH1lPiHb7qSHvAJrsIDqaTTWXHNbNw1
         RnRaEX260i8MHMtQuKgHrIitqEs1uqwOqsg0GXlhyMiYryUXZRQmTiCBax5uXeUM3r+Y
         OdxFLy4qznJ3kkCxsZMdy2dX5NRolP/Q5/JxiiIq1prK19H2Al+BO5nQDqwMzyvDQb/+
         ZKKiPW9QX7EJRp+u7bHf9OgJ0qd7tVqpHygSF9IAC/zGllqT+oyB8SSHLTeCBGuCuS0P
         JodhcE0/IUz92AkJipW9kcqyBTsBb/8PV2mTllYfsjeUuUQ73Eb09NqChqkR8qD98Mav
         Ageg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8KkgfUadDs/hkl85C1FLCMdEQpgE7qKS4mK1asC94oc=;
        b=veEgbZoD3vM189QwoHdcDc2FGzyuh8QG5obGRhjqNZ5IBavdk0OJWKUxxuVcwfn2dQ
         d15jyh7PYUd9UWimsgZDnk6FFpFgVtk/TOVvDT2MmbBekvIeq1Alhapo2Ap+Je6Q52t+
         IaeuQKN7S6IrUunWSZmCEZLMB1Fsw8mcmbVadBdoTs5hWkhR+QRk0ZWiWPahJ3KMrsWO
         CFIccmt3esu+Nzt4M6eS/2GQiqo2Dd7NE/2EZ9fyF6w8pOJiaJzLLcPjxznCEUHzvnyE
         fgj2AERjUWfkRgs7AgG3gv+V+VFdv3Tzq082uWRvQhlWybDcpj+ue4RxuFxilSo1KIRf
         41Dw==
X-Gm-Message-State: AOAM531TLMYOTIfNpigVFn5zzm51scvuDqcmsltnCKhnOapDaQh1u6yj
        5QbKnosCeSoh6w0i8x/hRsV2Cg==
X-Google-Smtp-Source: ABdhPJyKKKglvWjNfbdtbYMY09vA5H1gIuwuNSQ8SlFG8X+Tu0BTtihPUdUIGlRjsBlzwhZ1nCkhUg==
X-Received: by 2002:a17:902:ccc6:b0:156:a94a:9db4 with SMTP id z6-20020a170902ccc600b00156a94a9db4mr38310087ple.45.1649793779966;
        Tue, 12 Apr 2022 13:02:59 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q17-20020aa79831000000b0050566040330sm21289476pfl.126.2022.04.12.13.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:02:59 -0700 (PDT)
Date:   Tue, 12 Apr 2022 20:02:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v4 03/10] KVM: selftests: Read binary stats desc in lib
Message-ID: <YlXa7+mOQOV26XUH@google.com>
References: <20220411211015.3091615-1-bgardon@google.com>
 <20220411211015.3091615-4-bgardon@google.com>
 <YlTN3yq1iBPkw6Aa@google.com>
 <CANgfPd8mZ9-zQBvK=OASQ+n7eq_FpvpStMc_yD-UsmFdQ3OCvA@mail.gmail.com>
 <YlXMxcKVgWxHtiGR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlXMxcKVgWxHtiGR@google.com>
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

On Tue, Apr 12, 2022, Sean Christopherson wrote:
> On Tue, Apr 12, 2022, Ben Gardon wrote:
> > On Mon, Apr 11, 2022 at 5:55 PM Mingwei Zhang <mizhang@google.com> wrote:
> > > I was very confused on header->name_size. So this field means the
> > > maximum string size of a stats name, right? Can we update the comments
> > > in the kvm.h to specify that? By reading the comments, I don't really
> > > feel this is how we should use this field.
> > 
> > I believe that's right. I agree the documentation on that was a little
> > confusing.
> 
> Heh, a little.  I got tripped up looking at this too.  Give me a few minutes and
> I'll attach a cleanup patch to add comments and fix the myriad style issues.
> 
> This whole file is painful to look at.  Aside from violating preferred kernel
> style, it's horribly consistent with itself.  Well, except for the 80 char limit,
> to which it has a fanatical devotion.

If you send a new version of this series, can you add this on top?

From: Sean Christopherson <seanjc@google.com>
Date: Tue, 12 Apr 2022 11:49:59 -0700
Subject: [PATCH] KVM: selftests: Clean up coding style in binary stats test

Fix a variety of code style violations and/or inconsistencies in the
binary stats test.  The 80 char limit is a soft limit and can and should
be ignored/violated if doing so improves the overall code readability.

Specifically, provide consistent indentation and don't split expressions
at arbitrary points just to honor the 80 char limit.

Opportunistically expand/add comments to call out the more subtle aspects
of the code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/kvm_binary_stats_test.c     | 91 ++++++++++++-------
 1 file changed, 56 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 97b180249ba0..944ed52e3f07 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -37,32 +37,42 @@ static void stats_test(int stats_fd)
 	/* Read kvm stats header */
 	read_vm_stats_header(stats_fd, &header);

+	/*
+	 * The base size of the descriptor is defined by KVM's ABI, but the
+	 * size of the name field is variable as far as KVM's ABI is concerned.
+	 * But, the size of name is constant for a given instance of KVM and
+	 * is provided by KVM in the overall stats header.
+	 */
 	size_desc = sizeof(*stats_desc) + header.name_size;

 	/* Read kvm stats id string */
 	id = malloc(header.name_size);
 	TEST_ASSERT(id, "Allocate memory for id string");
+
 	ret = read(stats_fd, id, header.name_size);
 	TEST_ASSERT(ret == header.name_size, "Read id string");

 	/* Check id string, that should start with "kvm" */
 	TEST_ASSERT(!strncmp(id, "kvm", 3) && strlen(id) < header.name_size,
-				"Invalid KVM stats type, id: %s", id);
+		    "Invalid KVM stats type, id: %s", id);

 	/* Sanity check for other fields in header */
 	if (header.num_desc == 0) {
 		printf("No KVM stats defined!");
 		return;
 	}
-	/* Check overlap */
-	TEST_ASSERT(header.desc_offset > 0 && header.data_offset > 0
-			&& header.desc_offset >= sizeof(header)
-			&& header.data_offset >= sizeof(header),
-			"Invalid offset fields in header");
+	/*
+	 * The descriptor and data offsets must be valid, they must not overlap
+	 * the header, and the descriptor and data blocks must not overlap each
+	 * other.  Note, the data block is rechecked after its size is known.
+	 */
+	TEST_ASSERT(header.desc_offset && header.desc_offset >= sizeof(header) &&
+		    header.data_offset && header.data_offset >= sizeof(header),
+		    "Invalid offset fields in header");
+
 	TEST_ASSERT(header.desc_offset > header.data_offset ||
-			(header.desc_offset + size_desc * header.num_desc <=
-							header.data_offset),
-			"Descriptor block is overlapped with data block");
+		    (header.desc_offset + size_desc * header.num_desc <= header.data_offset),
+		    "Descriptor block is overlapped with data block");

 	/* Read kvm stats descriptors */
 	stats_desc = alloc_vm_stats_desc(stats_fd, &header);
@@ -70,15 +80,22 @@ static void stats_test(int stats_fd)

 	/* Sanity check for fields in descriptors */
 	for (i = 0; i < header.num_desc; ++i) {
+		/*
+		 * Note, size_desc includes the of the name field, which is
+		 * variable, i.e. this is NOT equivalent to &stats_desc[i].
+		 */
 		pdesc = (void *)stats_desc + i * size_desc;
-		/* Check type,unit,base boundaries */
-		TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK)
-				<= KVM_STATS_TYPE_MAX, "Unknown KVM stats type");
-		TEST_ASSERT((pdesc->flags & KVM_STATS_UNIT_MASK)
-				<= KVM_STATS_UNIT_MAX, "Unknown KVM stats unit");
-		TEST_ASSERT((pdesc->flags & KVM_STATS_BASE_MASK)
-				<= KVM_STATS_BASE_MAX, "Unknown KVM stats base");
-		/* Check exponent for stats unit
+
+		/* Check type, unit, and base boundaries */
+		TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK) <= KVM_STATS_TYPE_MAX,
+			    "Unknown KVM stats type");
+		TEST_ASSERT((pdesc->flags & KVM_STATS_UNIT_MASK) <= KVM_STATS_UNIT_MAX,
+			    "Unknown KVM stats unit");
+		TEST_ASSERT((pdesc->flags & KVM_STATS_BASE_MASK) <= KVM_STATS_BASE_MAX,
+			    "Unknown KVM stats base");
+
+		/*
+		 * Check exponent for stats unit
 		 * Exponent for counter should be greater than or equal to 0
 		 * Exponent for unit bytes should be greater than or equal to 0
 		 * Exponent for unit seconds should be less than or equal to 0
@@ -89,47 +106,51 @@ static void stats_test(int stats_fd)
 		case KVM_STATS_UNIT_NONE:
 		case KVM_STATS_UNIT_BYTES:
 		case KVM_STATS_UNIT_CYCLES:
-			TEST_ASSERT(pdesc->exponent >= 0,
-					"Unsupported KVM stats unit");
+			TEST_ASSERT(pdesc->exponent >= 0, "Unsupported KVM stats unit");
 			break;
 		case KVM_STATS_UNIT_SECONDS:
-			TEST_ASSERT(pdesc->exponent <= 0,
-					"Unsupported KVM stats unit");
+			TEST_ASSERT(pdesc->exponent <= 0, "Unsupported KVM stats unit");
 			break;
 		}
 		/* Check name string */
 		TEST_ASSERT(strlen(pdesc->name) < header.name_size,
-				"KVM stats name(%s) too long", pdesc->name);
+			    "KVM stats name(%s) too long", pdesc->name);
 		/* Check size field, which should not be zero */
-		TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
-				pdesc->name);
+		TEST_ASSERT(pdesc->size,
+			    "KVM descriptor(%s) with size of 0", pdesc->name);
 		/* Check bucket_size field */
 		switch (pdesc->flags & KVM_STATS_TYPE_MASK) {
 		case KVM_STATS_TYPE_LINEAR_HIST:
 			TEST_ASSERT(pdesc->bucket_size,
-			    "Bucket size of Linear Histogram stats (%s) is zero",
-			    pdesc->name);
+				    "Bucket size of Linear Histogram stats (%s) is zero",
+				    pdesc->name);
 			break;
 		default:
 			TEST_ASSERT(!pdesc->bucket_size,
-			    "Bucket size of stats (%s) is not zero",
-			    pdesc->name);
+				    "Bucket size of stats (%s) is not zero",
+				    pdesc->name);
 		}
 		size_data += pdesc->size * sizeof(*stats_data);
 	}
-	/* Check overlap */
-	TEST_ASSERT(header.data_offset >= header.desc_offset
-		|| header.data_offset + size_data <= header.desc_offset,
-		"Data block is overlapped with Descriptor block");
+
+	/*
+	 * Now that the size of the data block is known, verify the data block
+	 * doesn't overlap the descriptor block.
+	 */
+	TEST_ASSERT(header.data_offset >= header.desc_offset ||
+		    header.data_offset + size_data <= header.desc_offset,
+		    "Data block is overlapped with Descriptor block");
+
 	/* Check validity of all stats data size */
 	TEST_ASSERT(size_data >= header.num_desc * sizeof(*stats_data),
-			"Data size is not correct");
+		    "Data size is not correct");
+
 	/* Check stats offset */
 	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = (void *)stats_desc + i * size_desc;
 		TEST_ASSERT(pdesc->offset < size_data,
-			"Invalid offset (%u) for stats: %s",
-			pdesc->offset, pdesc->name);
+			    "Invalid offset (%u) for stats: %s",
+			    pdesc->offset, pdesc->name);
 	}

 	/* Read kvm stats data one by one */

base-commit: f9955a6aaa037a7a8198a817b9d272efcf10961a
--

