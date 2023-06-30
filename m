Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7983743180
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 02:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbjF3ALL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 20:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjF3ALJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 20:11:09 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636702D50
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 17:11:08 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-262bf824505so852778a91.1
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 17:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688083868; x=1690675868;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CLAK2aaJMqt8JMt9rFyLuXa7SLZsuXSqltLsJC9Ut/I=;
        b=pafJgNqSlBfLIW/qP07meHoC4gZ7MF1KwU9BqieXtUH4Vh0Wj5OFtwZXoEUjt7NtI6
         oQ0Cy7ROucQoeyCtenftvliy0LnSZMFN18ofzMCCKELi9585Vwr8ffJoZgA6qx4jf2g2
         7RNcuQusOSh/RXk2d0VvBk5eKleqddXMRMF/FK8ZgPxJKPzl9Nxwp28xuuk2J9MvNDQr
         9RPO5JquPNQ3XNQx/n3Fv2l+LK9Q5wv6Stxv2+davIiFfFzcE4vuYb6226s76NERC8lv
         sltZCMLVNWZFEjFNz+r+sqwzIFWy7tC7MsRRYJsORDr/7ZYKP5+tnqldgLzK5l0ElgN3
         PVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688083868; x=1690675868;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CLAK2aaJMqt8JMt9rFyLuXa7SLZsuXSqltLsJC9Ut/I=;
        b=lizcUjo0oILnWOr6GhMWCazn7v42nAXDK/XuVQ7VMCpTQMo3GSiqg3EskbGUjiAftO
         QQ5c2imglSxBlZ01L/yKyGmSe6ntBhDF/zBrENLa8qfGogzFXm/UXzAAqzmg+3d1Y0HD
         b8dX7n5jL/ctsBghLDLD2Hc16200eZRIpTvOT1PQXxW4PA8JgJWpaMZ2dlzp+mslfb64
         OF5q7GtGp3WzgWLo94o9iRiZNCP4j85Ty07Cex2O0yQmeD8F463P3DkktIiZmpc6ancl
         xPo/4FLuaxvQg0e3+w/F1BWjV/aXmxurJrdhaKmF3hH4abtzSqCVl8xQj9t9C/zvzKqu
         evUA==
X-Gm-Message-State: ABy/qLZxK+cT0VNNqc9QJNd55SO0bkR2GpCTehY0E8NfnClup/PUJAkk
        HWTczd1W0d1i4Nn+u351WdIdBTZdmcs=
X-Google-Smtp-Source: APBJJlHHfs2HzeDQUGiyPhu0LQ4LqgREP7UJhyRp5LdVIvQGqUvmDQHybH8Q7DwIiJhY9yPbuVy0VMHVIvU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:d82:b0:25b:809a:c7a with SMTP id
 bg2-20020a17090b0d8200b0025b809a0c7amr416383pjb.3.1688083867787; Thu, 29 Jun
 2023 17:11:07 -0700 (PDT)
Date:   Thu, 29 Jun 2023 17:11:06 -0700
In-Reply-To: <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
Message-ID: <ZJ4dmrQSduY8aWap@google.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>,
        Roman Kagan <rkagan@amazon.de>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Mingwei

On Thu, Jun 29, 2023, Jim Mattson wrote:
> On Mon, Jun 5, 2023 at 5:51=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Thu, May 04, 2023, Roman Kagan wrote:
> > > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > > index 5c7bbf03b599..6a91e1afef5a 100644
> > > --- a/arch/x86/kvm/pmu.h
> > > +++ b/arch/x86/kvm/pmu.h
> > > @@ -60,6 +60,12 @@ static inline u64 pmc_read_counter(struct kvm_pmc =
*pmc)
> > >       return counter & pmc_bitmask(pmc);
> > >  }
> > >
> > > +static inline void pmc_set_counter(struct kvm_pmc *pmc, u64 val)
> > > +{
> > > +     pmc->counter +=3D val - pmc_read_counter(pmc);
> >
> > Ugh, not your code, but I don't see how the current code can possibly b=
e correct.
> >
> > The above unpacks to
> >
> >         counter =3D pmc->counter;
> >         if (pmc->perf_event && !pmc->is_paused)
> >                 counter +=3D perf_event_read_value(pmc->perf_event,
> >                                                  &enabled, &running);
> >         pmc->counter +=3D val - (counter & pmc_bitmask(pmc));
> >
> > which distills down to
> >
> >         counter =3D 0;
> >         if (pmc->perf_event && !pmc->is_paused)
> >                 counter +=3D perf_event_read_value(pmc->perf_event,
> >                                                  &enabled, &running);
> >         pmc->counter =3D val - (counter & pmc_bitmask(pmc));
> >
> > or more succinctly
> >
> >         if (pmc->perf_event && !pmc->is_paused)
> >                 val -=3D perf_event_read_value(pmc->perf_event, &enable=
d, &running);
> >
> >         pmc->counter =3D val;
> >
> > which is obviously wrong.  E.g. if the guest writes '0' to an active co=
unter, the
> > adjustment will cause pmc->counter to be loaded with a large (in unsign=
ed terms)
> > value, and thus quickly overflow after a write of '0'.
>=20
> This weird construct goes all the way back to commit f5132b01386b
> ("KVM: Expose a version 2 architectural PMU to a guests"). Paolo
> killed it in commit 2924b52117b2 ("KVM: x86/pmu: do not mask the value
> that is written to fixed PMUs"), perhaps by accident. Eric then
> resurrected it in commit 4400cf546b4b ("KVM: x86: Fix perfctr WRMSR
> for running counters").
>=20
> It makes no sense to me. WRMSR should just set the new value of the
> counter, regardless of the old value or whether or not it is running.

Heh, didn't stop you from giving Eric's patch a thumbs-up[*] :-)

Thanks to Eric's testcase [Wow, tests do help!  We should try writing more =
of them!],
I finally figured out what's going on.  I wrongly assumed perf_event_read_v=
alue()
is destructive, but it's not, it just reads the current value.  So on a WRM=
SR,
KVM offsets the value with the current perf event, and then *mostly* adjust=
s for
it when reading the counter.

But that is obviously super fragile because it means pmc->counter must neve=
r be
read directly unless the perf event is paused and the accumulated counter h=
as been
propagated to pmc->counter.  Blech.

I fiddled with a variety of things, but AFAICT the easiest solution is also=
 the
most obviously correct: set perf's count to the guest's count.  Lightly tes=
ted
patch below.

On a related topic, Mingwei also appears to have found another bug: prev_co=
unter
needs to be set when the counter is written, i.e. my proposed pmc_write_cou=
nter()
also needs to update prev_counter.

Though that also raises the question of whether or not zeroing prev_counter=
 in
reprogram_counter() is correct.  Unless I'm missing something, reprogram_co=
unter()
should also set pmc->prev_counter to pmc->counter when the counter is succe=
ssfully
(re)enabled.

And Jim also pointed out that prev_counter needs to be set even when KVM fa=
ils
to enable a perf event (software counting should still work).

[*] https://lore.kernel.org/all/CALMp9eRfeFFb6n22Uf4R2Pf8WW7BVLX_Vuf04WFwiM=
trk14Y-Q@mail.gmail.com

---
 arch/x86/kvm/pmu.h           |  8 ++++++++
 arch/x86/kvm/svm/pmu.c       |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c |  4 ++--
 include/linux/perf_event.h   |  2 ++
 kernel/events/core.c         | 11 +++++++++++
 5 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7d9ba301c090..ba91a78e4dc1 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 	return counter & pmc_bitmask(pmc);
 }
=20
+static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
+{
+	if (pmc->perf_event && !pmc->is_paused)
+		perf_event_set_count(pmc->perf_event, val);
+
+	pmc->counter =3D val;
+}
+
 static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
 {
 	if (pmc->perf_event) {
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index cef5a3d0abd0..373ff6a6687b 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -160,7 +160,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
 	/* MSR_PERFCTRn */
 	pmc =3D get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
-		pmc->counter +=3D data - pmc_read_counter(pmc);
+		pmc_write_counter(pmc, data);
 		pmc_update_sample_period(pmc);
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 80c769c58a87..18a658aa2a8d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -406,11 +406,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, s=
truct msr_data *msr_info)
 			if (!msr_info->host_initiated &&
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data =3D (s64)(s32)data;
-			pmc->counter +=3D data - pmc_read_counter(pmc);
+			pmc_write_counter(pmc, data);
 			pmc_update_sample_period(pmc);
 			break;
 		} else if ((pmc =3D get_fixed_pmc(pmu, msr))) {
-			pmc->counter +=3D data - pmc_read_counter(pmc);
+			pmc_write_counter(pmc, data);
 			pmc_update_sample_period(pmc);
 			break;
 		} else if ((pmc =3D get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d5628a7b5eaa..8fcd52a87ba2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1677,6 +1677,7 @@ extern void perf_event_disable_inatomic(struct perf_e=
vent *event);
 extern void perf_event_task_tick(void);
 extern int perf_event_account_interrupt(struct perf_event *event);
 extern int perf_event_period(struct perf_event *event, u64 value);
+extern void perf_event_set_count(struct perf_event *event, u64 count);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
@@ -1760,6 +1761,7 @@ static inline int perf_event_period(struct perf_event=
 *event, u64 value)
 {
 	return -EINVAL;
 }
+static inline perf_event_set_count(struct perf_event *event, u64 count) { =
}
 static inline u64 perf_event_pause(struct perf_event *event, bool reset)
 {
 	return 0;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index db016e418931..d368c283eba5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5646,6 +5646,17 @@ static void _perf_event_reset(struct perf_event *eve=
nt)
 	perf_event_update_userpage(event);
 }
=20
+void perf_event_set_count(struct perf_event *event, u64 count)
+{
+	struct perf_event_context *ctx;
+
+	ctx =3D perf_event_ctx_lock(event);
+	(void)perf_event_read(event, false);
+	local64_set(&event->count, count);
+	perf_event_ctx_unlock(event, ctx);
+}
+EXPORT_SYMBOL_GPL(perf_event_set_count);
+
 /* Assume it's not an event with inherit set. */
 u64 perf_event_pause(struct perf_event *event, bool reset)
 {

base-commit: 5ae85a1bd17b959796f6cc4c1153ceada2cf8f24
--=20
