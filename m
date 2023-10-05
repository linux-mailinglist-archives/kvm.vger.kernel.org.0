Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882BF7B993E
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 02:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244106AbjJEAaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 20:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbjJEAaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 20:30:01 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BBDC1
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 17:29:58 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-27911ce6206so351445a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 17:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696465797; x=1697070597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HP82+f2LW6og6nQMkdcaVuem0dmBP2uW2zMzUlSKFRQ=;
        b=imJGrfrSMe5fW+gOt1/z+NlKJkfFdy4a4Uv4N0mbip6T87AseqQvFkdczhffRQhpEE
         TovjWNNhqucSugBbWcy9AogsMuQU83AKeb/gjOx6B7e7Orf945vIFmbA57tg1PldAU4Q
         QDSK7LPE/03UWAoC7zrg1qJsc2ENn6Ic2XwFt+kdylVn/zav8WQ8xtSErlpqTXGeYYHN
         Ut43HbhWyVSj33O45g22UqiUrOKecoQ898kNC2Uu5+fRf1iGmx9VEJFSaUHZ6OvJuvDf
         9ZxQfjPpB9P/1xayzE9072dJD+1oFktH2ApSLz9w1cD6SwKiK+iFVn8kA4YCIj8wajPN
         5hCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696465797; x=1697070597;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HP82+f2LW6og6nQMkdcaVuem0dmBP2uW2zMzUlSKFRQ=;
        b=QjL1xJl8ksMtv46wwobakJQZryWmPGR02JBszWmTLhJcDmT/EbPh1br2dhuarvvaur
         Jpq6oF6JOVn79HJOeC4cNwxkSp8nSZk6Z/OyOi4HBeJ/VkXe1u1xWZkwqGV01+fNa6+9
         3nsvTYPTW0rKj34/bdxADSqGRqnM4PhUWoYAeojchqbr5uluN/mpDjb4uRHguW8ocNqS
         2n4IojqotUk0R3nNV3K0hQ0oamyPpMJAvo1Wdtz1fR8s2lyOQjmerZEkk3M3my7/ZUlT
         TpmojtwxP057Tc2hHBXgK/RJFiftICeK//nZ8ZSMWzw7t5m6Uk8wop6JxysaSIWlWDw1
         UioA==
X-Gm-Message-State: AOJu0YwagbLuh7k/kvU38gm0c6mdqS4qF5kaLHi8ZqHo0934uczf1U2N
        8YAmd8s6hfY/bh82xzekbEwMPZ4WQC0=
X-Google-Smtp-Source: AGHT+IGjuzVmG4VrIEg6onoQka9/53erdP0YimQdq07KZJ4spZD7LQ7Lg79Ey1OYCRt1OWkHM4AxCAz5QWk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a393:b0:274:90a4:f29 with SMTP id
 x19-20020a17090aa39300b0027490a40f29mr61931pjp.1.1696465797603; Wed, 04 Oct
 2023 17:29:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 Oct 2023 17:29:54 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20231005002954.2887098-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Zero-initialize entire test_result in memslot
 perf test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zero-initialize the entire test_result structure used by memslot_perf_test
instead of zeroing only the fields used to guard the pr_info() calls.

gcc 13.2.0 is a bit overzealous and incorrectly thinks that rbestslottim's
slot_runtime may be used uninitialized.

  In file included from memslot_perf_test.c:25:
  memslot_perf_test.c: In function =E2=80=98main=E2=80=99:
  include/test_util.h:31:22: error: =E2=80=98rbestslottime.slot_runtime.tv_=
nsec=E2=80=99 may be used uninitialized [-Werror=3Dmaybe-uninitialized]
     31 | #define pr_info(...) printf(__VA_ARGS__)
        |                      ^~~~~~~~~~~~~~~~~~~
  memslot_perf_test.c:1127:17: note: in expansion of macro =E2=80=98pr_info=
=E2=80=99
   1127 |                 pr_info("Best slot setup time for the whole test =
area was %ld.%.9lds\n",
        |                 ^~~~~~~
  memslot_perf_test.c:1092:28: note: =E2=80=98rbestslottime.slot_runtime.tv=
_nsec=E2=80=99 was declared here
   1092 |         struct test_result rbestslottime;
        |                            ^~~~~~~~~~~~~
  include/test_util.h:31:22: error: =E2=80=98rbestslottime.slot_runtime.tv_=
sec=E2=80=99 may be used uninitialized [-Werror=3Dmaybe-uninitialized]
     31 | #define pr_info(...) printf(__VA_ARGS__)
        |                      ^~~~~~~~~~~~~~~~~~~
  memslot_perf_test.c:1127:17: note: in expansion of macro =E2=80=98pr_info=
=E2=80=99
   1127 |                 pr_info("Best slot setup time for the whole test =
area was %ld.%.9lds\n",
        |                 ^~~~~~~
  memslot_perf_test.c:1092:28: note: =E2=80=98rbestslottime.slot_runtime.tv=
_sec=E2=80=99 was declared here
   1092 |         struct test_result rbestslottime;
        |                            ^~~~~~~~~~~~~

That can't actually happen, at least not without the "result" structure in
test_loop() also being used uninitialized, which gcc doesn't complain
about, as writes to rbestslottime are all-or-nothing, i.e. slottimens can't
be non-zero without slot_runtime being written.

	if (!data->mem_size &&
	    (!rbestslottime->slottimens ||
	     result.slottimens < rbestslottime->slottimens))
		*rbestslottime =3D result;

Zero-initialize the structures to make gcc happy even though this is
likely a compiler bug.  The cost to do so is negligible, both in terms of
code and runtime overhead.  The only downside is that the compiler won't
warn about legitimate usage of "uninitialized" data, e.g. the test could
end up consuming zeros instead of useful data.  However, given that the
test is quite mature and unlikely to see substantial changes, the odds of
introducing such bugs are relatively low, whereas being able to compile
KVM selftests with -Werror detects issues on a regular basis.

Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

I don't like papering over compiler bugs, but this is causing me quite a bi=
t of
pain, and IMO the long-term downsides are quite minimal.  And I already spe=
nt
way too much time trying to figure out if there is some bizarre edge case t=
hat
gcc is detecting :-/

 tools/testing/selftests/kvm/memslot_perf_test.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testin=
g/selftests/kvm/memslot_perf_test.c
index 20eb2e730800..8698d1ab60d0 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -1033,9 +1033,8 @@ static bool test_loop(const struct test_data *data,
 		      struct test_result *rbestruntime)
 {
 	uint64_t maxslots;
-	struct test_result result;
+	struct test_result result =3D {};
=20
-	result.nloops =3D 0;
 	if (!test_execute(targs->nslots, &maxslots, targs->seconds, data,
 			  &result.nloops,
 			  &result.slot_runtime, &result.guest_runtime)) {
@@ -1089,7 +1088,7 @@ int main(int argc, char *argv[])
 		.seconds =3D 5,
 		.runs =3D 1,
 	};
-	struct test_result rbestslottime;
+	struct test_result rbestslottime =3D {};
 	int tctr;
=20
 	if (!check_memory_sizes())
@@ -1098,11 +1097,10 @@ int main(int argc, char *argv[])
 	if (!parse_args(argc, argv, &targs))
 		return -1;
=20
-	rbestslottime.slottimens =3D 0;
 	for (tctr =3D targs.tfirst; tctr <=3D targs.tlast; tctr++) {
 		const struct test_data *data =3D &tests[tctr];
 		unsigned int runctr;
-		struct test_result rbestruntime;
+		struct test_result rbestruntime =3D {};
=20
 		if (tctr > targs.tfirst)
 			pr_info("\n");
@@ -1110,7 +1108,6 @@ int main(int argc, char *argv[])
 		pr_info("Testing %s performance with %i runs, %d seconds each\n",
 			data->name, targs.runs, targs.seconds);
=20
-		rbestruntime.runtimens =3D 0;
 		for (runctr =3D 0; runctr < targs.runs; runctr++)
 			if (!test_loop(data, &targs,
 				       &rbestslottime, &rbestruntime))

base-commit: 013858c6fc2491c70640556385d5af123d1596c5
--=20
2.42.0.582.g8ccd20d70d-goog

