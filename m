Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABE16A9B41
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 16:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjCCPyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 10:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjCCPyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 10:54:36 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6431A97D;
        Fri,  3 Mar 2023 07:54:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1FDA82052F;
        Fri,  3 Mar 2023 15:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1677858873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OX0Zk32MxB1SguOJCebjGzfeq9YQ/kNosNxS6sooeUo=;
        b=YFSJtO8U5aF5USp1qkar0ddcOveTlTvcnxa4rifI37EyJbdz/878UzFCplMOx2DVEGu49x
        jdDbxoF+HircpHnXUCGKozAu+NchrWC7iGKUZjLaoa4+h9bkeLNnOcqGM1nuAuYQ6RYOeG
        mNi4paflRft0fZP9SLKZBM7zGZxXUb8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1677858873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OX0Zk32MxB1SguOJCebjGzfeq9YQ/kNosNxS6sooeUo=;
        b=VamsRLAwn96KJo2H0gpwvGwTmBzd958veUi4ZII21ILNcW2KQ/Kh09Btzewxn0B/GCf5jK
        XZ6SYNliBwRObfDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 894881329E;
        Fri,  3 Mar 2023 15:54:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id b/O0IDgYAmQhSQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 03 Mar 2023 15:54:32 +0000
Message-ID: <4846fdcd-3e13-548b-dc2c-a47dc163885f@suse.cz>
Date:   Fri, 3 Mar 2023 16:54:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v8 23/56] crypto: ccp: Introduce snp leaked pages list
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-24-michael.roth@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230220183847.59159-24-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 19:38, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Pages are unsafe to be released back to the page-allocator, if they
> have been transitioned to firmware/guest state and can't be reclaimed
> or transitioned back to hypervisor/shared state. In this case add
> them to an internal leaked pages list to ensure that they are not freed
> or touched/accessed to cause fatal page faults.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 28 ++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      |  8 ++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 35f605936f1b..eca4e59b0f44 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -42,6 +42,12 @@
>  static DEFINE_MUTEX(sev_cmd_mutex);
>  static struct sev_misc_dev *misc_dev;
>  
> +/* list of pages which are leaked and cannot be reclaimed */
> +static LIST_HEAD(snp_leaked_pages_list);
> +static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
> +
> +static atomic_long_t snp_nr_leaked_pages = ATOMIC_LONG_INIT(0);
> +
>  static int psp_cmd_timeout = 100;
>  module_param(psp_cmd_timeout, int, 0644);
>  MODULE_PARM_DESC(psp_cmd_timeout, " default timeout value, in seconds, for PSP commands");
> @@ -188,6 +194,28 @@ static int sev_cmd_buffer_len(int cmd)
>  	return 0;
>  }
>  
> +void snp_mark_pages_offline(unsigned long pfn, unsigned int npages)

Why call it offline which has usually a memory hotplug-related meaning? What
about e.g. snp_leak_bad_pages() ?

> +{
> +	struct page *page = pfn_to_page(pfn);
> +
> +	WARN(1, "psc failed, pfn 0x%lx pages %d (marked offline)\n", pfn, npages);
> +
> +	spin_lock(&snp_leaked_pages_list_lock);
> +	while (npages--) {
> +		/*
> +		 * Reuse the page's buddy list for chaining into the leaked
> +		 * pages list. This page should not be on a free list currently
> +		 * and is also unsafe to be added to a free list.
> +		 */
> +		list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
> +		sev_dump_rmpentry(pfn);
> +		pfn++;
> +	}
> +	spin_unlock(&snp_leaked_pages_list_lock);
> +	atomic_long_inc(&snp_nr_leaked_pages);
> +}
> +EXPORT_SYMBOL_GPL(snp_mark_pages_offline);
> +
>  static void *sev_fw_alloc(unsigned long len)
>  {
>  	struct page *page;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 46f61e3ae33b..8edf5c548fbf 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -923,6 +923,12 @@ int sev_do_cmd(int cmd, void *data, int *psp_ret);
>  
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
>  
> +/**
> + * sev_mark_pages_offline - insert non-reclaimed firmware/guest pages
> + * into a leaked pages list.
> + */
> +void snp_mark_pages_offline(unsigned long pfn, unsigned int npages);
> +
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  static inline int
> @@ -951,6 +957,8 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
>  
>  static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
>  
> +void snp_mark_pages_offline(unsigned long pfn, unsigned int npages) {}
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */

