Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB94E583616
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 02:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbiG1AyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 20:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiG1AyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 20:54:24 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722E952DD9;
        Wed, 27 Jul 2022 17:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658969663; x=1690505663;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=0nfawnvMVpJjUKIVgH438/VExd/K0Alihlzhk5ai7fQ=;
  b=eHg4Ih0QeE/i8PRhAizCbLUfAL9Y8csP5wPGTFwJgYyeDvbDApJhPRKM
   R2Curv/Js1zx1MZ80O//piKqHY3Y6WjcYglirZCMLAZVcp9ZIvGCx25do
   Jrw7JUzAUnMXa1aPJf48NvuaVqfBq+tqOUktzFwnKkLyRj71RhV9WjWu+
   dnM2hazO1nwj1kZRDC21KsmDRh1IQLfJfWKjMXws6YIcPhScaKlTpFy5M
   Gn6Ue0nHv7YuUCHv9Hoge3dU93jm4/Z6b10+RZ5Ficw4uOenbhnq0KcH2
   xWoc4/Uk0UYvbaCaA0Ra9w/biBPHsDbKnd7xBQewM1gdtXAQql9vwHN3c
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="285931765"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="285931765"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 17:54:23 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="703526918"
Received: from lmcmurch-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.76.147])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 17:54:21 -0700
Message-ID: <af9e3b06ba9e16df4bfd768dfdd78f2e0277cbe5.camel@intel.com>
Subject: Re: [PATCH v7 041/102] KVM: VMX: Introduce test mode related to EPT
 violation VE
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 28 Jul 2022 12:54:20 +1200
In-Reply-To: <20220727233955.GC3669189@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <cadf3221e3f7b911c810f15cfe300dd5337a966d.1656366338.git.isaku.yamahata@intel.com>
         <52915310c9118a124da2380daf3d753a818de05e.camel@intel.com>
         <20220719144936.GX1379820@ls.amr.corp.intel.com>
         <9945dbf586d8738b7cf0af53bfb760da9eb9e882.camel@intel.com>
         <20220727233955.GC3669189@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-27 at 16:39 -0700, Isaku Yamahata wrote:
> On Wed, Jul 20, 2022 at 05:13:08PM +1200,
> Kai Huang <kai.huang@intel.com> wrote:
>=20
> > On Tue, 2022-07-19 at 07:49 -0700, Isaku Yamahata wrote:
> > > On Fri, Jul 08, 2022 at 02:23:43PM +1200,
> > > Kai Huang <kai.huang@intel.com> wrote:
> > >=20
> > > > On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > >=20
> > > > > To support TDX, KVM is enhanced to operate with #VE.  For TDX, KV=
M programs
> > > > > to inject #VE conditionally and set #VE suppress bit in EPT entry=
.  For VMX
> > > > > case, #VE isn't used.  If #VE happens for VMX, it's a bug.  To be
> > > > > defensive (test that VMX case isn't broken), introduce option
> > > > > ept_violation_ve_test and when it's set, set error.
> > > >=20
> > > > I don't see why we need this patch.  It may be helpful during your =
test, but why
> > > > do we need this patch for formal submission?
> > > >=20
> > > > And for a normal guest, what prevents one vcpu from sending #VE IPI=
 to another
> > > > vcpu?
> > >=20
> > > Paolo suggested it as follows.  Maybe it should be kernel config.
> > > (I forgot to add suggested-by. I'll add it)
> > >=20
> > > https://lore.kernel.org/lkml/84d56339-4a8a-6ddb-17cb-12074588ba9c@red=
hat.com/
> > >=20
> > > >=20
> >=20
> > OK.  But can we assume a normal guest won't sending #VE IPI?
>=20
> Theoretically nothing prevents that.  I wouldn't way "normal".
> Anyway this is off by default.

I don't think whether it is on or off by default matters.  If it can happen
legitimately in the guest, it doesn't look right to print out something lik=
e
below:

	pr_err("VMEXIT due to unexpected #VE.\n");

Anyway, will let maintainers to decide.

--=20
Thanks,
-Kai


