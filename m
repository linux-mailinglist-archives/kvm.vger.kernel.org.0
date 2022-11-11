Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FDE625FC8
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 17:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbiKKQqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 11:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiKKQqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 11:46:19 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA47A659B;
        Fri, 11 Nov 2022 08:46:17 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 972F72021B;
        Fri, 11 Nov 2022 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1668185176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IZJVk5r9PKhQ9UO4qjsE5Lk3TQEeuw8BnTCEAw5ed8M=;
        b=aEna/nUu0X2GzLFJfUsOqrZm6LE84zOQpgwqT8gjJG10wwMwEbzCBcKpM/oEje+6bHkis2
        tKoqfDhTUw9sq6Tr9YgMTkJvWDEEPnxomAtNC7ykGmXydZRMt8dTz7bAnDAyyM9TiY4PqB
        TC7DpJPMBzLVKmrlQ9IaymVKjIEAT6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1668185176;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IZJVk5r9PKhQ9UO4qjsE5Lk3TQEeuw8BnTCEAw5ed8M=;
        b=uXa4PUrYev+PFpAz+Js5gL6RJfSc4fw+kf2xYhsARpfGPALk9GI/wtGozJAbGaT3XlfqSR
        U/VYxi0A/WgvspCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 89A7713357;
        Fri, 11 Nov 2022 16:46:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fceVIVh8bmPhXQAAMHmgww
        (envelope-from <bp@suse.de>); Fri, 11 Nov 2022 16:46:16 +0000
Date:   Fri, 11 Nov 2022 17:46:11 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Peter Gonda <pgonda@google.com>
Cc:     thomas.lendacky@amd.com, Dionna Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V4] virt: sev: Prevent IV reuse in SNP guest driver
Message-ID: <Y258U+8oF/eo14U+@zn.tnic>
References: <20221103152318.88354-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221103152318.88354-1-pgonda@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022 at 08:23:18AM -0700, Peter Gonda wrote:
> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to

ASP?

That must be the AMD Secure Processor or so but pls write it out.

> communicate securely with each other. The IV to this scheme is a
> sequence number that both the ASP and the guest track. Currently this
> sequence number in a guest request must exactly match the sequence
> number tracked by the ASP. This means that if the guest sees an error
> from the host during a request it can only retry that exact request or
> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> reuse see:
> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf

Right, how stable will that link be?

IOW, perhaps quote the paper name and authors so that people can find it
on their own.

> To handle userspace querying the cert_data length handle_guest_request()
> now: saves the number of pages required by the host, retries the request

This needs to sound like this:

"In order to address this, save the number of pages ..."

IOW, as the docs say:

"Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
to do frotz", as if you are giving orders to the codebase to change
its behaviour."

> without requesting the extended data, then returns the number of pages
> required.
> 
> Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")

I'm guessing this needs to go to stable?

> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reported-by: Peter Gonda <pgonda@google.com>
> Cc: Dionna Glaze <dionnaglaze@google.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Haowen Bai <baihaowen@meizu.com>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ashish Kalra <Ashish.Kalra@amd.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org
> ---
> Tested by placing each of the guest requests: attestation quote,
> extended attestation quote, and get key. Then tested the extended
> attestation quote certificate length querying.
> 
> V4
>  * As suggested by Dionna moved the extended request retry logic into
>    the driver.
>  * Due to big change in patch dropped any reviewed-by tags.
> 
> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 70 +++++++++++++++++++------
>  1 file changed, 53 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index f422f9c58ba79..7dd6337ebdd5b 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -41,7 +41,7 @@ struct snp_guest_dev {
>  	struct device *dev;
>  	struct miscdevice misc;
>  
> -	void *certs_data;
> +	u8 (*certs_data)[SEV_FW_BLOB_MAX_SIZE];
>  	struct snp_guest_crypto *crypto;
>  	struct snp_guest_msg *request, *response;
>  	struct snp_secrets_page_layout *layout;
> @@ -67,8 +67,27 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>  	return true;
>  }
>  
> +/*
> + * If we receive an error from the host or ASP we have two options. We can

Please use passive voice in your commit message: no "we" or "I", etc,
and describe your changes in imperative mood.

Bottom line is: personal pronouns are ambiguous in text, especially with
so many parties/companies/etc developing the kernel so let's avoid them
please.

> + * either retry the exact same encrypted request or we can discontinue using the
> + * VMPCK.
> + *
> + * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
> + * encrypt the requests. The IV for this scheme is the sequence number. GCM
> + * cannot tolerate IV reuse.
> + *
> + * The ASP FW v1.51 only increments the sequence numbers on a successful
> + * guest<->ASP back and forth and only accepts messages at its exact sequence
> + * number.
> + *
> + * So if we were to reuse the sequence number the encryption scheme is
> + * vulnerable. If we encrypt the sequence number for a fresh IV the ASP will
> + * reject our request.
> + */
>  static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>  {
> +	dev_alert(snp_dev->dev, "Disabling vmpck_id: %d to prevent IV reuse.\n",
> +		  vmpck_id);
>  	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
>  	snp_dev->vmpck = NULL;
>  }
> @@ -323,32 +342,49 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
>  
>  	/* Call firmware to process the request */
>  	rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
> +
> +	/*
> +	 * If the extended guest request fails due to having to small of a

"... too small... "

> +	 * certificate data buffer retry the same guest request without the
> +	 * extended data request.
> +	 */
> +	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
> +	    err == SNP_GUEST_REQ_INVALID_LEN) {
> +		const unsigned int certs_npages = snp_dev->input.data_npages;
> +
> +		exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> +		rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
> +
> +		err = SNP_GUEST_REQ_INVALID_LEN;

Huh, why are we overwriting err here?

> +		snp_dev->input.data_npages = certs_npages;
> +	}
> +
>  	if (fw_err)
>  		*fw_err = err;
>  
> -	if (rc)
> -		return rc;
> +	if (rc) {
> +		dev_alert(snp_dev->dev,
> +			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
> +			  rc, *fw_err);
> +		goto disable_vmpck;
> +	}
>  
> -	/*
> -	 * The verify_and_dec_payload() will fail only if the hypervisor is
> -	 * actively modifying the message header or corrupting the encrypted payload.
> -	 * This hints that hypervisor is acting in a bad faith. Disable the VMPCK so that
> -	 * the key cannot be used for any communication. The key is disabled to ensure
> -	 * that AES-GCM does not use the same IV while encrypting the request payload.
> -	 */
>  	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
>  	if (rc) {
>  		dev_alert(snp_dev->dev,
> -			  "Detected unexpected decode failure, disabling the vmpck_id %d\n",
> -			  vmpck_id);
> -		snp_disable_vmpck(snp_dev);
> -		return rc;
> +			  "Detected unexpected decode failure from ASP. rc: %d\n",
> +			  rc);
> +		goto disable_vmpck;
>  	}
>  
>  	/* Increment to new message sequence after payload decryption was successful. */
>  	snp_inc_msg_seqno(snp_dev);
>  
>  	return 0;
> +
> +disable_vmpck:
> +	snp_disable_vmpck(snp_dev);
> +	return rc;
>  }
>  
>  static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
> @@ -676,7 +712,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	if (!snp_dev->response)
>  		goto e_free_request;
>  
> -	snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
> +	snp_dev->certs_data = alloc_shared_pages(dev, sizeof(*snp_dev->certs_data));

What's that change for?

I went searching for that ->certs_data only ot realize that it is an
array of size of SEV_FW_BLOB_MAX_SIZE elems.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
